package pixeldroid.util.file
{
    import system.platform.File;
    import system.platform.Path;


    /**
        A utlity class for manipulating file paths.
    */
    public final class FilePath
    {
        /**
            Returns all components of the given filepath except the last one.

            The returned string does not contain a trailing delimiter.

            @param filepath Path to a file for which the containing directory is desired

            @return Path up to but not including the file or a trailing delimiter
        */
        public static function dirname(filepath:String):String
        {
            var lastD = filepath.lastIndexOf(Path.getFolderDelimiter());

            return (lastD == -1) ? filepath : filepath.substring(0, lastD);
        }

        /**
            Returns the last component of the given filepath.

            If extension is given and found at the end of `filepath`, it is removed.
            If extension is `.*`, any extension will be removed.

            @param filepath Path to a file for which the filename is desired
            @param extension File suffix to remove. Either as a wildcard (`.*`), or as a literal string not including `.` (e.g. `png` or `txt`)

            @return Filename from the given path, optionally with extension removed
        */
        public static function basename(filepath:String, extension:String = null):String
        {
            var name:String = filepath.split(Path.getFolderDelimiter()).pop();

            if (extension)
            {
                var dot:Number = name.lastIndexOf('.');
                var ext:String = name.substring(dot, name.length);
                if ('.*' == extension || ext == extension) name = name.substring(0, dot);
            }

            return name;
        }

        /**
            Returns any characters after the last period (`.`) in the given filepath.

            If no period exists in the filename, the empty string is returned.
            If a period is the last character in the filename, the empty string is returned.

            @param filepath Path to a file for which the file extension is desired

            @return File extension from the given path, or empty string
        */
        public static function extname(filepath:String):String
        {
            var dot:Number = filepath.lastIndexOf('.');
            return (dot < 0) ? '' : filepath.substring(dot + 1, filepath.length);
        }

        /**
            Tests that path exists and is a directory on the filesystem.

            @param path Path to test as a directory

            @return `true` when path is a directory
        */
        public static function isDir(path:String):Boolean
        {
            return Path.dirExists(path);
        }

        /**
            Tests that path exists and is a file on the filesystem.

            @param path Path to test as a file

            @return `true` when path is a file, and not a directory
        */
        public static function isFile(path:String):Boolean
        {
            if (File.fileExists(path))
            {
                // dirs are counted as files, so need to check if dir or truly file
                return (Path.dirExists(path) ? false : true);
            }
            else
            {
                return false;
            }
        }

        /**
            Combines the given components into a path delimited by the system folder delimiter.

            Components can be any mix of single string values, single objects that provide
            a `toString()` method, or Vectors of strings or objects:
              - `FilePath.join('a', 'b', 'c', 'file.ext')`
              - `FilePath.join('a', ['b', 'c'], 'file.ext')`
              - `FilePath.join('a', b, c, 'file.ext')    // where b,c .toString() are valid`
              - `FilePath.join('a', [b, c], 'file.ext')  // ^^`

            The returned string does not contain a trailing delimiter.

            With the exception of a leading delimiter on the first component,
            all leading and trailing delimiters will be stripped from individual components.

            Delimiters existing within a component are left alone.

            @param components Any mix of single string values, single objects that provide a `toString()` method, or Vectors of strings or objects

            @return Single string of components joined by the system folder delimiter, but without a trailing delimiter
        */
        public static function join(...components):String
        {
            components = components.filter(removeEmpty);
            return components.map(stringify).join(Path.getFolderDelimiter());
        }


        private static function removeEmpty(thing:Object, index:Number):Boolean
        {
            if (thing is Vector) return (Vector(thing).length > 0);
            return (String(thing).length > 0);
        }

        private static function stringify(thing:Object, index:Number):String
        {
            var d:String = Path.getFolderDelimiter();
            var s:String = (thing is Vector) ? Vector(thing).join(d) : thing.toString();

            if (index > 0) while (s.charAt(0) == d) s = s.substring(1, s.length);
            while (s.charAt(s.length - 1) == d) s = s.substring(0, s.length - 1);

            return s;
        }

    }
}
