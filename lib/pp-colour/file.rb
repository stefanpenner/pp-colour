class File
  class Stat
    def pretty_print(q)
      require 'etc.so'
      q.object_group(self) {
        q.breakable
        q.text sprintf("dev=0x%x", self.dev); q.comma_breakable
        q.text "ino="; q.pp self.ino; q.comma_breakable
        q.group {
          m = self.mode
          q.text sprintf("mode=0%o", m)
          q.breakable
          q.text sprintf("(%s %c%c%c%c%c%c%c%c%c)",
            self.ftype,
            (m & 0400 == 0 ? ?- : ?r),
            (m & 0200 == 0 ? ?- : ?w),
            (m & 0100 == 0 ? (m & 04000 == 0 ? ?- : ?S) :
                             (m & 04000 == 0 ? ?x : ?s)),
            (m & 0040 == 0 ? ?- : ?r),
            (m & 0020 == 0 ? ?- : ?w),
            (m & 0010 == 0 ? (m & 02000 == 0 ? ?- : ?S) :
                             (m & 02000 == 0 ? ?x : ?s)),
            (m & 0004 == 0 ? ?- : ?r),
            (m & 0002 == 0 ? ?- : ?w),
            (m & 0001 == 0 ? (m & 01000 == 0 ? ?- : ?T) :
                             (m & 01000 == 0 ? ?x : ?t)))
        }
        q.comma_breakable
        q.text "nlink="; q.pp self.nlink; q.comma_breakable
        q.group {
          q.text "uid="; q.pp self.uid
          begin
            pw = Etc.getpwuid(self.uid)
          rescue ArgumentError
          end
          if pw
            q.breakable; q.text "(#{pw.name})"
          end
        }
        q.comma_breakable
        q.group {
          q.text "gid="; q.pp self.gid
          begin
            gr = Etc.getgrgid(self.gid)
          rescue ArgumentError
          end
          if gr
            q.breakable; q.text "(#{gr.name})"
          end
        }
        q.comma_breakable
        q.group {
          q.text sprintf("rdev=0x%x", self.rdev)
          q.breakable
          q.text sprintf('(%d, %d)', self.rdev_major, self.rdev_minor)
        }
        q.comma_breakable
        q.text "size="; q.pp self.size; q.comma_breakable
        q.text "blksize="; q.pp self.blksize; q.comma_breakable
        q.text "blocks="; q.pp self.blocks; q.comma_breakable
        q.group {
          t = self.atime
          q.text "atime="; q.pp t
          q.breakable; q.text "(#{t.tv_sec})"
        }
        q.comma_breakable
        q.group {
          t = self.mtime
          q.text "mtime="; q.pp t
          q.breakable; q.text "(#{t.tv_sec})"
        }
        q.comma_breakable
        q.group {
          t = self.ctime
          q.text "ctime="; q.pp t
          q.breakable; q.text "(#{t.tv_sec})"
        }
      }
    end
  end
end

