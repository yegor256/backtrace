# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative '../lib/backtrace'
require_relative 'test__helper'

# Backtrace test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class BacktraceTest < Minitest::Test
  def test_prints_exception
    raise(RuntimeError, 'Just a test')
  rescue StandardError => e
    text = Backtrace.new(e).to_s
    assert_includes(text, "RuntimeError: Just a test\n", text)
    assert_includes(text, 'test/test_backtrace.rb', text)
  end

  def test_prints_synthetic_exception
    text = Backtrace.new(StandardError.new('boom!')).to_s
    assert_includes(text, 'StandardError: boom!', text)
  end

  def test_preserves_frames_when_mine_does_not_match
    error = RuntimeError.new('request failed')
    frames = ['/vendor/http.rb:41', '/worker/queue.rb:9']
    error.set_backtrace(frames)
    ['/application', %r{/application}].each do |mine|
      assert_equal("RuntimeError: request failed\n\t#{frames.join("\n\t")}", Backtrace.new(error, mine: mine).to_s)
    end
  end

  def test_stops_at_last_matching_frame
    error = RuntimeError.new('request failed')
    error.set_backtrace(
      ['/vendor/http.rb:41', '/application/inner.rb:5', '/application/outer.rb:9', '/worker/queue.rb:9']
    )
    ['/application', %r{/application}].each do |mine|
      assert_equal(
        "RuntimeError: request failed\n\t/vendor/http.rb:41\n\t/application/inner.rb:5\n\t/application/outer.rb:9",
        Backtrace.new(error, mine: mine).to_s
      )
    end
  end

  def test_logs_frames_when_mine_does_not_match
    log = FakeLog.new
    error = RuntimeError.new('request failed')
    error.set_backtrace(['/vendor/http.rb:41', '/worker/queue.rb:9'])
    Backtrace.exec(swallow: true, log: log, mine: '/application') { raise(error) }
    assert_equal("RuntimeError: request failed\n\t/vendor/http.rb:41\n\t/worker/queue.rb:9", log.sent)
  end

  def test_runs_a_block
    log = FakeLog.new
    Backtrace.exec(swallow: true, log: log) do
      raise(RuntimeError, 'It is intended')
    end
    assert_includes(log.sent, 'intended')
  end

  def test_runs_a_block_to_console
    Backtrace.exec(swallow: true, mine: 'backtrace') do
      raise(RuntimeError, 'It is intended')
    end
  end

  def test_runs_a_block_to_broken_log
    Backtrace.exec(swallow: true, log: Object.new) do
      raise(RuntimeError, 'It is intended')
    end
  end

  class FakeLog
    attr_reader :sent

    def error(msg)
      @sent = msg
    end
  end
end
