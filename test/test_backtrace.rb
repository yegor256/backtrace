# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/backtrace'

# Backtract test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
class BacktraceTest < Minitest::Test
  def test_prints_exception
    raise 'Just a test'
  rescue StandardError => e
    text = Backtrace.new(e).to_s
    assert(text.include?("RuntimeError: Just a test\n"), text)
    assert(text.include?('test/test_backtrace.rb'), text)
  end

  def test_runs_a_block
    log = FakeLog.new
    Backtrace.exec(swallow: true, log: log) do
      raise 'It is intended'
    end
    assert(log.sent.include?('intended'))
  end

  def test_runs_a_block_to_console
    Backtrace.exec(swallow: true, mine: 'backtrace') do
      raise 'It is intended'
    end
  end

  def test_runs_a_block_to_broken_log
    Backtrace.exec(swallow: true, log: Object.new) do
      raise 'It is intended'
    end
  end

  class FakeLog
    attr_reader :sent

    def error(msg)
      @sent = msg
    end
  end
end
