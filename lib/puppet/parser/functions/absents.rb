module Puppet::Parser::Functions
  newfunction(:absents, :type => :rvalue, :doc => <<-EOS
      Returns a hash of the elements that have ensure == absent.
    EOS
  ) do |args|
    raise(Puppet::ParseError, "absents(): Wrong number of arguments given") if args.size != 1

    args[0].select{ |k, v| v['ensure'] == 'absent' }
  end
end
