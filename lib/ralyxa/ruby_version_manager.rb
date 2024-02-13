module Ralyxa
    module RubyVersionManager

        def self.included(base)
            base.include RubyVersionManagerMethods
        end
        
        module RubyVersionManagerMethods
            def manage_ruby_version_for(klass, method:, data:, ruby_version_that_introduce_breaking_changes: "3")
                RUBY_VERSION < ruby_version_that_introduce_breaking_changes ? klass.send(method, data) : klass.send(method, **data)
            end
        end
  
    end
end
  
# include Ralyxa::RubyVersionManager for every class that raise ArgumentError
# this exception is caused by separation of positional and keyword arguments differences between Ruby 2 and 3
# https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
[ Ralyxa::ResponseBuilder, Ralyxa::Handler ].each { |klass| klass.include(Ralyxa::RubyVersionManager) } 