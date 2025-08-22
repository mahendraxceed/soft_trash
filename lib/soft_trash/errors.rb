# frozen_string_literal: true

module SoftTrash

  #
  # Generic exception class.
  class SoftTrashError < StandardError
  end


  class RecordNotTrasheded < SoftTrashError
    attr_reader :record

    def initialize(message = nil, record = nil)
      @record = record
      super(message)
    end
  end


  class RecordNotRecovered < SoftTrashError
    attr_reader :record

    def initialize(message = nil, record = nil)
      @record = record
      super(message)
    end
  end
end