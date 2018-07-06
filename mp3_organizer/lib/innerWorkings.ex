defmodule InnerWorkings do

    @mp3 "mp3s"

    @moduledoc """
    This module describes the inner workings of the application. 
    It includes the refresh cycle, list functions and search functions.
    """

    @doc """
    Looks up the directory and writes it down in a file once every 5 seconds. It is run in the background and stopped when the app is stopped.
    """
    def refreshRepeatedly(dir) do
        receive do
            {:ok, "stop"} -> File.rm!(@mp3)
            {:ok, "start"} -> refreshOnce(dir)
                              Process.sleep(5000)
                              send(self(), {:ok, "start"})
                              refreshRepeatedly(dir)
        end
    end

    @doc """
    Prints all of the songs in the directory arranged by artist and returns their tags in a list of lists.

    Example:
        iex> InnerWorkings.listArrangedByArtist("../test_dir")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You
        Dubioza Kolektiv: Dubioza Kolektiv - Be Highirly


        [
            ["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"],
            ["Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"]
        ]
    """
    def listArrangedByArtist(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, a | _] = x 
                                            [_, b | _] = y 
                                            a < b end)
        customPrint(sorted)
        Enum.map(sorted, fn(x) -> [_, a, b, c] = x
                                  [a, b, c] end)
    end

    @doc """
    Prints all of the songs in the directory arranged by album and returns their tags in a list of lists.

    Example:
        iex> InnerWorkings.listArrangedByAlbum("../test_dir")
        Dubioza Kolektiv: Dubioza Kolektiv - Be Highirly
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [
            ["Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"],
            ["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]
        ]
    """
    def listArrangedByAlbum(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, a | _] = x 
                                            [_, _, b | _] = y 
                                            a < b end)
        customPrint(sorted)
        Enum.map(sorted, fn(x) -> [_, a, b, c] = x
                                  [a, b, c] end)
    end

    @doc """
    Prints all of the songs in the directory arranged by title and returns their tags in a list of lists.

    Example:
        iex> InnerWorkings.listArrangedByTitle("../test_dir")
        Dubioza Kolektiv: Dubioza Kolektiv - Be Highirly
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [
            ["Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"],
            ["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]
        ]
    """
    def listArrangedByTitle(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, _, a | _] = x 
                                            [_, _, _, b | _] = y 
                                            a < b end)
        customPrint(sorted)
        Enum.map(sorted, fn(x) -> [_, a, b, c] = x
                                  [a, b, c] end)
    end

    @doc """
    Looks up an artist in the directory and lists all of their songs as well as returning their tags as a list of lists.
    Also searches by substrings.

    Example:
        iex> InnerWorkings.searchByArtist("../test_dir", "Alice Cooper")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
        iex> InnerWorkings.searchByArtist("../test_dir", "e Co")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
    """
    def searchByArtist(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, a | _] = x 
                                                a =~ search end)
        case length(filtered) do
            0 -> IO.puts("Nothing found!")
                 []
            _ -> customPrint(filtered)
                 Enum.map(filtered, fn(x) -> [_, a, b, c] = x
                                             [a, b, c] end)
        end
    end

    @doc """
    Looks up an album in the directory and lists all of songs in it as well as returning their tags as a list of lists.
    Also searches by substrings.

    Example:
        iex> InnerWorkings.searchByArtist("../test_dir", "Welcome 2 My Nightmare")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
        iex> InnerWorkings.searchByArtist("../test_dir", "ightma")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
    """
    def searchByAlbum(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, _, a | _] = x 
                                                a =~ search end)
        case length(filtered) do
            0 -> IO.puts("Nothing found!")
                 []
            _ -> customPrint(filtered)
                 Enum.map(filtered, fn(x) -> [_, a, b, c] = x
                                             [a, b, c] end)
        end
    end

    @doc """
    Looks up a title in the directory and lists all of songs with that title as well as returning their tags as a list of lists.
    Also searches by substrings.

    Example:
        iex> InnerWorkings.searchByArtist("../test_dir", "I Am Made Of You")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
        iex> InnerWorkings.searchByArtist("../test_dir", "ade O")
        Alice Cooper: Welcome 2 My Nightmare - I Am Made Of You


        [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
    """
    def searchByTitle(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, _, _, a | _] = x 
                                                a =~ search end)
        case length(filtered) do
            0 -> IO.puts("Nothing found!")
                 []
            _ -> customPrint(filtered)
                 Enum.map(filtered, fn(x) -> [_, a, b, c] = x
                                             [a, b, c] end)
        end
    end

    @doc """
    Renames all of the mp3 files in the given directory and all of its subdirectories. Afterwards it rereads the directory and writes it down. This function returns nothing.
    """
    def renameAll(dir, pattern) do
        tags = getFullMp3ListFromFile(dir)
        pathTuples = formatNamesByPattern(tags, pattern)
        renameFiles(pathTuples)
        refreshOnce(dir)
    end

    @doc """
    Renames all of the mp3 files in the given directory and all of its subdirectories that have a given artist. Afterwards it rereads the directory and writes it down. This function returns nothing.
    """
    def renameByArtist(dir, artist, pattern) do
        tags = getFullMp3ListFromFile(dir)
        tags = Enum.filter(tags, fn(x) -> [_, a | _] = x
                                          a == artist end)
        case length(tags) do
            0 -> IO.puts("Nothing found")
            _ -> pathTuples = formatNamesByPattern(tags, pattern)
                 renameFiles(pathTuples)
                 refreshOnce(dir)
        end
    end

    @doc """
    Renames all of the mp3 files in the given directory and all of its subdirectories that have a given album. Afterwards it rereads the directory and writes it down. This function returns nothing.
    """
    def renameByAlbum(dir, album, pattern) do
        tags = getFullMp3ListFromFile(dir)
        Enum.filter(tags, fn(x) -> [_, _, a | _] = x
                                   a == album end)
        case length(tags) do
            0 -> IO.puts("Nothing found")
            _ -> pathTuples = formatNamesByPattern(tags, pattern)
                 renameFiles(pathTuples)
                 refreshOnce(dir)
        end
    end

    @doc """
    Renames all of the mp3 files in the given directory and all of its subdirectories that have a given title. Afterwards it rereads the directory and writes it down. This function returns nothing.
    """
    def renameByTitle(dir, title, pattern) do
        tags = getFullMp3ListFromFile(dir)
        Enum.filter(tags, fn(x) -> [_, _, _, a | _] = x
                                   a == title end)
        case length(tags) do
            0 -> IO.puts("Nothing found")
            _ -> pathTuples = formatNamesByPattern(tags, pattern)
                 renameFiles(pathTuples)
                 refreshOnce(dir)
        end
    end

    # renames files. it receives a list of lists with 2 elements - the current path to it and the one we're going to set. if for some reason the renaming fails, we log a message into the console, but we do not raise a exception.
    defp renameFiles([]), do: _ = ""
    defp renameFiles([[old, new] | tail]) do
        renamed = File.rename(old, new)
        case renamed do
            {:error, _} -> IO.puts("FAILED TO RENAME " <> old <> "!!!!!\n")
            _ -> _ = ""
        end
        renameFiles(tail)
    end

    # we have 3 possible patterns to rename files to. we recursively go through a list of mp3 infos and constructs the new name for the file.
    defp formatNamesByPattern([], _), do: []
    defp formatNamesByPattern([head | tail], 1) do
        # Pattern 1 is <artist> - <title>
        [path, artist, _, title] = head
        separated = String.split(path, "/")
        newName = artist <> " - " <> title <> ".mp3"
        [[path, Enum.join(getNewPath(separated, newName), "/")]] ++ formatNamesByPattern(tail, 1)
    end
    defp formatNamesByPattern([head | tail], 2) do
        # Pattern 2 is <artist>(<album>) - <title>
        [path, artist, album, title] = head
        separated = String.split(path, "/")
        newName = artist <> "(" <> album <> ") - " <> title <> ".mp3"
        [[path, Enum.join(getNewPath(separated, newName), "/")]] ++ formatNamesByPattern(tail, 2)
    end
    defp formatNamesByPattern([head | tail], 3) do
        # Pattern 3 is <title>
        [path, _, _, title] = head
        separated = String.split(path, "/")
        newName = title <> ".mp3"
        [[path, Enum.join(getNewPath(separated, newName), "/")]] ++ formatNamesByPattern(tail, 3)
    end

    # constructs puts the parts of the path in a list in the correct order
    defp getNewPath([_], newName), do: [newName]
    defp getNewPath([head | tail], newName) do
        [head] ++ getNewPath(tail, newName)
    end

    # prints a list of mp3 infos
    defp customPrint([]), do: IO.puts("\n")
    defp customPrint([[_, artist, album, title] | tail]) do
        IO.puts(artist <> ": " <> album <> " - " <> title)
        customPrint(tail)
    end

    # compiles all of the mp3 infos into a single string to be written into a file
    defp compileStringForMp3sFile([]), do: ""
    defp compileStringForMp3sFile([head | tail]) do
        [path, artist, album, title] = head
        path <> "#" <> artist <> "#" <> album <> "#" <> title <> "@" <> compileStringForMp3sFile(tail)
    end

    # reads the directory, reads all of the info for the mp3s, compiles it into a string and writes it into the file
    defp refreshOnce(dir) do
        files = DirReader.readPathRecursively(dir)
        files = getOnlyMp3Files(files)
        filesWithTagsRead = Mp3Reader.readMultipleMp3s(files)
        if File.exists?(@mp3) do
            File.rm!(@mp3)
        end
        File.write(@mp3, compileStringForMp3sFile(filesWithTagsRead))
        files
    end

    # reads a list of mp3 infos from the files and returns it. in the end we filter out the lists with length 4, because otherwise we would have a [""] at the end, which creates issues later in the execution of the app.
    defp getFullMp3ListFromFile(dir) do
        refreshOnce(dir)
        tags = Enum.map(String.split(File.read!(@mp3), "@"), fn(x) -> String.split(x, "#") end)
        Enum.filter(tags, fn(x) -> length(x) == 4 end)
    end

    # takes a list of files' and directories' paths and returns only those which are to mp3 files.
    defp getOnlyMp3Files(files) when is_list(files), do: Enum.filter(files, fn(x) -> String.slice(x, -4..-1) == ".mp3" end)
end