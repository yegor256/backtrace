# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Backtrace as a string.
#
# This class helps format Ruby exceptions with their backtraces
# in a clean, readable format. It can also filter backtrace lines
# to show only relevant information.
#
# @example Basic usage
#   begin
#     raise "Something went wrong"
#   rescue => e
#     puts Backtrace.new(e)
#   end
#
# @example Using with a filter
#   begin
#     raise "Error in my code"
#   rescue => e
#     puts Backtrace.new(e, mine: 'myapp')
#   end
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class Backtrace
  # Creates a new Backtrace instance.
  #
  # @param exp [Exception] The exception to format
  # @param mine [String, Regexp] Pattern to match against backtrace lines.
  #   When matched, backtrace will stop printing at that line.
  #
  # @example With a string pattern
  #   Backtrace.new(exception, mine: 'myapp')
  #
  # @example With a regular expression
  #   Backtrace.new(exception, mine: /lib\/myapp/)
  def initialize(exp, mine: '')
    @exp = exp
    @mine = (mine.is_a?(Regexp) ? mine : Regexp.new(Regexp.quote(mine)))
  end

  # Converts the backtrace to a formatted string.
  #
  # The output includes the exception class name, message, and a filtered
  # backtrace. Lines are indented with tabs for readability.
  #
  # @return [String] Formatted backtrace string
  #
  # @example
  #   begin
  #     1 / 0
  #   rescue => e
  #     bt = Backtrace.new(e)
  #     puts bt.to_s
  #     # => "ZeroDivisionError: divided by 0
  #     #     \t/path/to/file.rb:10:in `/'
  #     #     \t/path/to/file.rb:20:in `calculate'"
  #   end
  def to_s
    bt = @exp.backtrace
      &.reverse
      &.drop_while { |t| @mine.match(t).nil? }
      &.reverse
      &.join("\n\t")
    [
      @exp.class.name,
      ': ',
      @exp.message,
      ("\n\t#{bt}" if bt)
    ].join
  end

  # Executes a block and handles exceptions with formatted backtrace.
  #
  # This method provides a convenient way to wrap code that might raise
  # exceptions. It will format and display (or log) any exceptions that occur.
  #
  # @param swallow [Boolean] Whether to swallow the exception (default: false)
  # @param log [Object] Logger object that responds to #error (optional)
  # @param mine [String, Regexp] Pattern to filter backtrace lines
  #
  # @yield The block of code to execute
  #
  # @raise [StandardError] Re-raises the exception unless swallow is true
  #
  # @example Basic usage
  #   Backtrace.exec do
  #     risky_operation
  #   end
  #
  # @example Swallow exceptions
  #   Backtrace.exec(swallow: true) do
  #     optional_operation
  #   end
  #
  # @example With logging
  #   logger = Logger.new(STDOUT)
  #   Backtrace.exec(log: logger) do
  #     database_operation
  #   end
  #
  # @example With filtering
  #   Backtrace.exec(mine: 'myapp', swallow: true) do
  #     complex_operation
  #   end
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
