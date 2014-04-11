module Puppet::Parser::Functions
  newfunction(:absents, :type => :rvalue, :doc => <<-EOS
      Returns a hash of the elements that have ensure == absent.
    EOS
  ) do |args|
    raise(Puppet::ArgumentError, "absents(): Wrong number of arguments given") if args.size != 1
    raise(Puppet::ArgumentError, "absents(): First parameter must be a hash") if args[0].class != Hash

    Hash[args[0].select{ |k, v| v['ensure'] == 'absent' }]
  end
end
