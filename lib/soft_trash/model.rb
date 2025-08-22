# frozen_string_literal: true

module SoftTrash
  # Handles soft deletes of records.
  #
  # Options:
  #
  # - :soft_trash_column - The columns used to track soft delete, defaults to `:deleted_at`.
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :soft_trash_column
      self.soft_trash_column = :deleted_at

      scope :active, ->{ where(soft_trash_column => nil) }
      scope :deleted, ->{ where.not(soft_trash_column => nil) }

      define_model_callbacks :trash
      define_model_callbacks :restore
    end

    # :nodoc:
    module ClassMethods

      #   Person.where(age: 0..18).trash_all
      def trash_all
        active.each(&:trash)
      end


      #
      #   Person.where(age: 0..18).trash_all!
      def trash_all!
        active.each(&:trash!)
      end


      #
      #   Person.where(age: 0..18).undiscard_all
      def restore_all
        deleted.each(&:restore)
      end

      # Undiscards the records by instantiating each
      # record and calling its {#undiscard!} method.
      # Each object's callbacks are executed.
      # Returns the collection of objects that were undiscarded.
      #
      # Note: Instantiation, callback execution, and update of each
      # record can be time consuming when you're undiscarding many records at
      # once. It generates at least one SQL +UPDATE+ query per record (or
      # possibly more, to enforce your callbacks). If you want to undiscard many
      # rows quickly, without concern for their associations or callbacks, use
      # #update_all!(discarded_at: nil) instead.
      #
      # ==== Examples
      #
      #   Person.where(age: 0..18).undiscard_all!
      def restore_all!
        deleted.each(&:restore!)
      end
    end

    # @return [Boolean] true if this record has been discarded, otherwise false
    def trashed?
      self[self.class.soft_trash_column].present?
    end

    # @return [Boolean] false if this record has been discarded, otherwise true
    def active?
      !trashed?
    end

    # Discard the record in the database
    #
    # @return [Boolean] true if successful, otherwise false
    def trash
      return false if trashed?
      run_callbacks(:trash) do
        update_attribute(self.class.soft_trash_column, Time.current)
      end
    end

    # Discard the record in the database
    #
    # There's a series of callbacks associated with #discard!. If the
    # <tt>before_discard</tt> callback throws +:abort+ the action is cancelled
    # and #discard! raises {Discard::RecordNotDiscarded}.
    #
    # @return [Boolean] true if successful
    # @raise {Discard::RecordNotDiscarded}
    def trash!
      trash || _raise_record_not_trashed
    end

    # Undiscard the record in the database
    #
    # @return [Boolean] true if successful, otherwise false
    def restore
      return false unless trashed?
      run_callbacks(:restore) do
        update_attribute(self.class.soft_trash_column, nil)
      end
    end


    def restore!
      restore || _raise_record_not_restoreed
    end

    private

    def _raise_record_not_trashed
      raise ::SoftTrash::RecordNotTrasheded.new(tarshed_fail_message, self)
    end

    def _raise_record_not_restoreed
      raise ::SoftTrash::RecordNotRecovered.new(restoreed_fail_message, self)
    end

    def tarshed_fail_message
      return "A trash record cannot be trashed" if trashed?

      "Failed to trash the record"
    end

    def restoreed_fail_message
      return "An active record cannot be restore" if active?

      "Failed to restore the record"
    end
  end
end