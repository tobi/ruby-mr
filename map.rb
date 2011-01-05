#!/usr/bin/env ruby

require 'lib/job'

class Wordcount < Job

  def initialize
    @prev_key, @key_total = nil, 0
  end

  def mapper(line)
    return unless line =~ /POST \/orders\/(\d+)\/([a-f0-9]+)\/commit/

    if line =~  /(iPhone|Android|Blackberry)/i
      yield $1.downcase, 1
    else
      yield 'browser', 1
    end
  end

  def reduce(key, value)

    if @prev_key && key != @prev_key && @key_total > 0
      yield @prev_key, @key_total
      @prev_key, @key_total = key, 0
    elsif !@prev_key
      @prev_key = key
    end

    @key_total += 1
  end
end

Wordcount.run
