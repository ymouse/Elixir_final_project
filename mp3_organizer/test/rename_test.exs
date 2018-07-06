defmodule RenameTest do
  use ExUnit.Case

  test "renameAllPattern1" do
    oldNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/I Am Made Of You.mp3"
    oldNameDubioza = Path.absname("test_dir") <> "/Dubioza Kolektiv/2004 - Dubioza Kolektiv/Be Highirly.mp3"
    expectedNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/Alice Cooper - I Am Made Of You.mp3"
    expectedNameDubioza = Path.absname("test_dir") <> "/Dubioza Kolektiv/2004 - Dubioza Kolektiv/Dubioza Kolektiv - Be Highirly.mp3"
    InnerWorkings.renameAll(Path.absname("test_dir"), 1)
    assert File.exists?(expectedNameAliceCooper)
    assert File.exists?(expectedNameDubioza)
    File.rename(expectedNameAliceCooper, oldNameAliceCooper)
    File.rename(expectedNameDubioza, oldNameDubioza)
  end

  test "renameByArtist" do
    oldNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/I Am Made Of You.mp3"
    expectedNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/Alice Cooper - I Am Made Of You.mp3"
    InnerWorkings.renameByArtist(Path.absname("test_dir"),"Alice Cooper", 1)
    assert File.exists?(expectedNameAliceCooper)
    File.rename(expectedNameAliceCooper, oldNameAliceCooper)
  end

  test "renameByAlbum" do
    oldNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/I Am Made Of You.mp3"
    expectedNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/Alice Cooper - I Am Made Of You.mp3"
    InnerWorkings.renameByAlbum(Path.absname("test_dir"),"Welcome 2 My Nightmare", 1)
    assert File.exists?(expectedNameAliceCooper)
    File.rename(expectedNameAliceCooper, oldNameAliceCooper)
  end

  test "renameByTitle" do
    oldNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/I Am Made Of You.mp3"
    expectedNameAliceCooper = Path.absname("test_dir") <> "/Alice Cooper/Alice Cooper - I Am Made Of You.mp3"
    InnerWorkings.renameByTitle(Path.absname("test_dir"),"I Am Made Of You", 1)
    assert File.exists?(expectedNameAliceCooper)
    File.rename(expectedNameAliceCooper, oldNameAliceCooper)
  end
end