defmodule ServerLog.ServerLogger do
  require Logger

  def log_a_message do
    {:ok,
     case :rand.uniform(4) do
       1 ->
         Logger.info("Info me!")
         :info

       2 ->
         Logger.error("Error me!")
         :error

       3 ->
         Logger.warning("Warn me!")
         :warning

       4 ->
         Logger.debug("Debug me!")
         :debug
     end}
  end
end
