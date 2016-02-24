class Saphyr::Core::Kernel
  def print *args
    ::Kernel.print *args.map(&:sprint)
  end

  def newline n = Saphyr::Core::Number.new(1)
    ::Kernel.print "\n"*n.intern
  end
end
