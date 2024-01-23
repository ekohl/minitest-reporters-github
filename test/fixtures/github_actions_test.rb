require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest_reporters_github'

Minitest::Reporters.use! MinitestReportersGithub.new

class TestClass < Minitest::Test
  def test_assertion
    assert true
  end

  def test_fail
    if true
      assert false
    end
  end
end
