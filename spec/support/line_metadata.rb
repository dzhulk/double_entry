require 'double_entry/line_metadata'
require 'double_entry/line'

class DoubleEntry::Line
  def metadata
    if DoubleEntry.config.json_metadata
      read_attribute(:metadata)
    end
  end

  def metadata=(meta)
    if DoubleEntry.config.json_metadata
      write_attribute(:metadata, meta)
    else
      raise "Can't write to metadata"
    end
  end
end
