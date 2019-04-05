Puppet::Parser::Functions.newfunction(:strformat, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
  Extrapolates scope variables in a string. Variables to be extrapolated must be in `%{}` blocks.

  The extrapolation is recursive, and works with hash values.

  Examples:

      $foo = 'Hello'
      $bar = { 'baz' => { 'quux' => 'World' } }
      $elem = 'baz'
      $return = strformat('%{foo}, %{bar["%{elem}"]["quux"]}') 
  ENDHEREDOC

  raise(Puppet::ParseError, "strformat(): Wrong number of arguments given") if args.size != 1
  raise(Puppet::ParseError, "strformat(): First parameter must be a string") if args[0].class != String

  result = args[0]
  while result =~ /%/
    result = result.gsub(/%\{([^%\[\}]+)([^%\}]*)\}/) { eval("self[$1]#{$2}") }
  end
  result
end
