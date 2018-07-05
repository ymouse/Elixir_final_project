defmodule RenameTest do
  use ExUnit.Case
  doctest InnerWorkings

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
end