defmodule Mp3ReaderTest do
  use ExUnit.Case
  doctest Mp3Reader

  test "readID3Tags" do
    result = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(DirReader.readPathRecursively(Path.absname("test_dir"))))
    assert result == [[Path.absname("test_dir") <> "/Alice Cooper/I Am Made Of You.mp3", "Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"], [Path.absname("test_dir") <> "/Dubioza Kolektiv/2004 - Dubioza Kolektiv/Be Highirly.mp3", "Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"]]
  end
  
  defp getOnlyMp3Files(files) when is_list(files), do: Enum.filter(files, fn(x) -> String.slice(x, -4..-1) == ".mp3" end)
end
