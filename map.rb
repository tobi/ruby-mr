#!/usr/bin/env ruby

$LOAD_PATH.unshift 'lib'

require 'job'

class Wordcount < Job

  def mapper(line)
    line.split.each do |word|
      yield word.downcase, 1
    end
  end

  def reduce(key, value)

    aggregate(key) do |key, count|
      yield key, count
    end

  end
end

Wordcount.run
