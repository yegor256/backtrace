# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Backtrace as a string.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
class Backtrace
  def initialize(exp, mine: '')
    @exp = exp
    @mine = (mine.is_a?(Regexp) ? mine : Regexp.new(Regexp.quote(mine)))
  end

  def to_s
    [
      @exp.class.name,
      ': ',
      @exp.message,
      "\n\t",
      @exp.backtrace.reverse
        .drop_while { |t| @mine.match(t).nil? }
        .reverse.join("\n\t")
    ].join
  end

  def self.exec(swallow: false, log: nil, mine: '')
    yield
  rescue StandardError => e
    trace = Backtrace.new(e, mine: mine).to_s
    if log.nil? || !log.respond_to?(:error)
      puts trace
    else
      log.error(trace)
    end
    raise e unless swallow
  end
end
