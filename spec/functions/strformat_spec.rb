require 'spec_helper'

describe Puppet::Parser::Functions.function(:strformat) do
  let (:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function(:strformat)).to eq('function_strformat')
  end

  it 'should raise a ParseError if there is less than 1 argument' do
    expect { scope.function_strformat([]) }.to raise_error(Puppet::ParseError)
  end

  it 'should lookup a string variables' do
    Puppet[:code] = <<-'ENDofPUPPETcode'
      $foo = 'Hello'
      $bar = 'World'
      if strformat('%{foo}, %{bar}') != 'Hello, World' {
        fail('strformat did not return what we expect')
      }
    ENDofPUPPETcode
    scope.compiler.compile
  end

  it 'should lookup a hash variables with a static key' do
    Puppet[:code] = <<-'ENDofPUPPETcode'
      $foo = 'Hello'
      $bar = { 'baz' => 'World' }
      if strformat('%{foo}, %{bar[\'baz\']}') != 'Hello, World' {
        fail('strformat did not return what we expect')
      }
    ENDofPUPPETcode
    scope.compiler.compile
  end

  it 'should lookup a hash variables with a variable key' do
    Puppet[:code] = <<-'ENDofPUPPETcode'
      $foo = 'Hello'
      $bar = { 'baz' => 'World' }
      $id = 'baz'
      $return = strformat('%{foo}, %{bar[\'%{id}\']}')
      $expect = 'Hello, World'
      if $return != $expect {
        fail("strformat did not return what we expect (returned ${return}, expected ${expected}")
      }
    ENDofPUPPETcode
    scope.compiler.compile
  end

  it 'should lookup a hash of hash variables with a variable key' do
    Puppet[:code] = <<-'ENDofPUPPETcode'
      $foo = 'Hello'
      $bar = { 'baz' => { 'quux' => 'World' } }
      $id = 'baz'
      $return = strformat('%{foo}, %{bar[\'%{id}\'][\'quux\']}')
      $expect = 'Hello, World'
      if $return != $expect {
        fail("strformat did not return what we expect (returned ${return}, expected ${expected}")
      }
    ENDofPUPPETcode
    scope.compiler.compile
  end

end
