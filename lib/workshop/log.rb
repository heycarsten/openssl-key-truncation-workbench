module Workshop
  class Log
    RED   = 31
    GREEN = 32
    PINK  = 35
    GRAY  = 37
    TCOLS = `tput cols`.to_i

    def red(str)
      color_str(RED, str)
    end

    def green(str)
      color_str(GREEN, str)
    end

    def pink(str)
      color_str(PINK, str)
    end

    def gray(str)
      color_str(GRAY, str)
    end

    def color_str(code, str)
      "\e[#{code}m#{str}\e[0m"
    end

    def bold(str)
      "\e[1m#{str}\e[22m"
    end

    def head(msg, pre_newline = true)
      puts '' if pre_newline
      puts bold("=== #{msg}")
    end

    def task(msg)
      puts "#{bold(' ->')} #{msg}"
    end

    def info(msg)
      puts gray("  - #{msg}")
    end

    def succ(msg)
      puts green("  - #{msg}")
    end

    def fail(msg)
      puts red("  - #{msg}")
    end

    def backtrace(error)
      fail("FAIL: #{error.class}")
      fail(error.message)

      error.backtrace.each do |line|
        puts red("    #{line}")
      end
    end

    def puts(str)
      out = if str.length > TCOLS
        str[0, TCOLS-1] + '…'
      else
        str
      end

      STDERR.puts(out)
    end
  end
end
