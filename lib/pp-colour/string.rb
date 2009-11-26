# credit goes to burke@burkelibbey.org
class String
  COLORS = {
    :black     => '0',
    :red       => '1',
    :green     => '2',
    :yellow    => '3',
    :blue      => '4',
    :magenta   => '5',
    :cyan      => '6',
    :white     => '7'
  }
 
  FORMAT_CODES = {
    :bold      => '1',
    :italic    => '3',
    :underline => '4',
    :blink     => '5',
  }
 
  def ansi_formatted
    ansi_csi = "#{(0x1B).chr}["
    formats = {}
    FORMAT_CODES.each do |name, code|
      formats[name] = code if @properties[name]
    end
    formats[:color] = "3#{COLORS[@properties[:color]]}" if @properties[:color]
    "#{ansi_csi}#{formats.values.join(';')}m#{self}#{ansi_csi}m"
  end
  
  def make_colorized(color)
    @properties ||= {}
    @properties[:color] = color
    ansi_formatted
  end
  
  COLORS.each do |color,v|
    eval <<-EOS
      def #{color.to_s}
        make_colorized(:#{color})
      end
    EOS
  end
 
  FORMAT_CODES.each do |name, code|
    eval <<-EOS
      def #{name}
        @properties ||= {}
        @properties[:#{name}] = true
        ansi_formatted
      end
    EOS
  end
end

