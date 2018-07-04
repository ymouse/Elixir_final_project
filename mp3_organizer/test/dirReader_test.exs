defmodule DirReaderTest do
  use ExUnit.Case
  doctest DirReader

  test "readsDirectory" do
    IO.puts("readsDirectory")
    read = DirReader.readPath(Path.absname("test_dir"))
    assert read == [Path.absname("test_dir") <> "/Alice Cooper", Path.absname("test_dir") <> "/Dubioza Kolektiv"]
  end
  
  test "readsDirectoryRecursive" do
    IO.puts("readsDirectoryRecursive")
    read = DirReader.readPathRecursively(Path.absname("test_dir"))
    assert read == [Path.absname("test_dir") <> "/Alice Cooper", Path.absname("test_dir") <> "/Dubioza Kolektiv", Path.absname("test_dir") <> "/Alice Cooper/01. I Am Made Of You.mp3", Path.absname("test_dir") <> "/Dubioza Kolektiv/2004 - Dubioza Kolektiv", Path.absname("test_dir") <> "/Dubioza Kolektiv/2004 - Dubioza Kolektiv/Be Highirly.mp3"]
  end
end
