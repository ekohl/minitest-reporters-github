# Taken from https://github.com/minitest-reporters/minitest-reporters/pull/332
# and adapted to be able to run as a standalone gem

require 'pathname'
require 'minitest/reporters'

# Inspired by the rubocop formatter.
# https://github.com/rubocop/rubocop/blob/2f8239f61bd41fe672a4cd9d6f24e334eba7854a/lib/rubocop/formatter/git_hub_actions_formatter.rb

# Simple reporter designed for Github Actions
class MinitestReportersGithub < Minitest::Reporters::BaseReporter
  ESCAPE_MAP = { '%' => '%25', "\n" => '%0A', "\r" => '%0D' }.freeze

  def start
    super

    print_run_options
  end

  def record(test)
    super

    print(message_for(test))
  end

  def message_for(test)
    if test.passed? || test.skipped?
      nil
    elsif test.failure
      to_annotation(test, "Failure")
    elsif test.error?
      to_annotation(test, "Error")
    end
  end

  private

  def to_annotation(test, failure_type)
    message = "#{failure_type}: #{test.name}\n\n#{test.failure.message}"
    line_number = location(test.failure).split(":").last

    "\n::error file=%<file>s,line=%<line>d::%<message>s\n" % {
      file: get_relative_path(test),
      line: line_number,
      message: github_escape(message.rstrip),
    }
  end

  def github_escape(string)
    string.gsub(Regexp.union(ESCAPE_MAP.keys), ESCAPE_MAP)
  end

  def get_source_location(result)
    if result.respond_to? :source_location
      result.source_location
    else
      result.method(result.name).source_location
    end
  end

  def location(exception)
    last_before_assertion = ''
    exception.backtrace.reverse_each do |s|
      break if s =~ /in .(assert|refute|flunk|pass|fail|raise|must|wont)/

      last_before_assertion = s
    end

    last_before_assertion.sub(/:in .*$/, '')
  end

  def get_relative_path(result)
    file_path = Pathname.new(get_source_location(result).first)
    base_path = Pathname.new(options[:base_path] || Dir.pwd)

    if file_path.absolute?
      file_path.relative_path_from(base_path)
    else
      file_path
    end
  end

  def print_run_options
    puts
    puts("# Running tests with run options %s:" % options[:args])
    puts
  end
end
