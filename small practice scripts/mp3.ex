defmodule Mp3 do

    def readPath(path) do
        filesRead = File.ls(path)
        case filesRead do
            {:ok, _} -> Enum.map(File.ls!(path), fn(x) -> path <> "/" <> x end)
            {:error, _} -> logFailedFolderRead(path)
        end
    end
    

    def readPathRecursively(path) do
        allFiles = readPath(path)
        subFolders = getOnlyFolders(allFiles)
        Enum.uniq(allFiles ++ readSubFolders(subFolders))
    end

    defp readSubFolders([]), do: []
    defp readSubFolders([head | tail]) do
        filesRead = File.ls(head)
        case filesRead do
            {:ok, _} -> Enum.map(File.ls!(head), fn(x) -> head <> "/" <> x end) ++ readPathRecursively(head) ++ readSubFolders(tail)
            {:error, _} -> logFailedFolderRead(head) ++ readSubFolders(tail)
        end
    end

    defp logFailedFolderRead(path) do
        IO.puts("Failed to read folder \"" <> path <> "\"!!!!!")
        []
    end
    defp getOnlyFolders(paths) when is_list(paths), do: Enum.filter(paths, fn(x) -> File.dir?(x) end)

    def readmp3s(files) do
        files = Enum.filter(files, fn(x) -> !File.dir?(x) end)
        reader(files)
    end

    def readMp3(mp3) do
        #{:ok, binary} = File.read(mp3)
        binary = File.read!(mp3)
        mp3_byte_size = (byte_size(binary) - 128)
        << _ :: binary - size(mp3_byte_size), id3_tag :: binary >> = binary
        binary
        << "TAG",
            title   :: binary - size(30), 
            artist  :: binary - size(30), 
            album   :: binary - size(30), 
            year    :: binary - size(4), 
            comment :: binary - size(30), 
            _   :: binary >> = id3_tag
        title
    end

    defp reader([]), do: []
    defp reader([head | tail]) do
        {:ok, binary } = File.read(head)
        mp3_byte_size = (byte_size(binary ) - 128)
        << _ :: binary-size(mp3_byte_size), id3_tag :: binary >> = binary
        reader(tail)
    end
end