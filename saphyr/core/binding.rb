class Saphyr::Core::Binding
  def initialize object
    @object = object
    @locals = {}
  end

  def assign name, args, value
#    p "assign #{name}, #{args}, #{value}"
    @locals[name] = ->(){ value }
  end

  def exec name, args
#p "exec #{name}, #{args}"

    if @locals.has_key? name
      @locals[name].call(*args)
    else
      @object.send(name, *args)
    end
  end
end
