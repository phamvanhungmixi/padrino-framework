module Padrino
  PADRINO_IGNORE_CALLERS = [
   %r{lib/padrino-.*$},         # all padrino code
   %r{/padrino-.*/(lib|bin)},   # all padrino code
   %r{/bin/padrino$},           # all padrino code
   %r{/sinatra},                # all sinatra code
   %r{lib/tilt.*\.rb$},         # all tilt code
   %r{lib/rack.*\.rb$},         # all rack code
   %r{lib/mongrel.*\.rb$},      # all mongrel code
   %r{lib/shotgun.*\.rb$},      # all shotgun lib
   %r{bin/shotgun$},            # shotgun binary
   %r{\(.*\)},                  # generated code
   %r{shoulda/context\.rb$},    # shoulda hacks
   %r{mocha/integration},       # mocha hacks
   %r{test/unit},               # test unit hacks
   %r{rake_test_loader\.rb},    # rake hacks
   %r{custom_require\.rb$},     # rubygems require hacks
   %r{active_support},          # active_support require hacks
   %r{/thor},                   # thor require hacks
  ] unless defined?(PADRINO_IGNORE_CALLERS)

  ##
  # Add rubinius (and hopefully other VM impls) ignore patterns ...
  #
  PADRINO_IGNORE_CALLERS.concat(RUBY_IGNORE_CALLERS) if defined?(RUBY_IGNORE_CALLERS)

  private
    ##
    # Returns the filename for the file that is the direct caller (first caller)
    #
    def self.first_caller
      caller_files.first
    end

    ##
    # Like Kernel#caller but excluding certain magic entries and without
    # line / method information; the resulting array contains filenames only.
    #
    def self.caller_files
      caller(1).
        map    { |line| line.split(/:(?=\d|in )/)[0,2] }.
        reject { |file,line| PADRINO_IGNORE_CALLERS.any? { |pattern| file =~ pattern } }.
        map    { |file,line| file }
    end
end # Padrino