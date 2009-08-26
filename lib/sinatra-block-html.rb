require 'sinatra/base'
require 'block-html'

module Sinatra
  module BlockHTML
    def bhtml(template=nil, options={}, locals={}, &block)
      require_warn('BlockHTML') unless defined?(::BlockHTML)

      options, template = template, nil if template.is_a?(Hash)
      template = lambda { block } if template.nil?
      render(:bhtml, template, options, locals).to_s
    end

  protected
    def render_bhtml(template, data, options, locals, &block)
      if data.respond_to?(:to_str)
        ::BlockHTML.new(self) do
          instance_eval(data)
        end
      elsif data.kind_of?(Proc)
        ::BlockHTML.new(self, &data)
      end
    end
  end

  helpers BlockHTML

  class Base
    include Sinatra::BlockHTML
  end
end
