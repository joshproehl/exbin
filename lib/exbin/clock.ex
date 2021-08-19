defmodule ExBin.Clock do
  @moduledoc """
  A wrapper around DateTime.utc_now that allows us to freeze time for testing purposes.
  Should be used in place of DateTime.utc_now/0 or Timex.now/0

  Protects the freeze feature so that the methods can never be called in an enviroment
  that hasn't specifically requested they be compiled in. No accidental shenanigans.

  Based on https://codeincomplete.com/articles/testing-dates-in-elixir/
  """

  @config Application.compile_env(:exbin, __MODULE__) || []

  if @config[:freezable] do
    def utc_now do
      Process.get(:mock_utc_now) || DateTime.utc_now
    end

    def freeze do
      Process.put(:mock_utc_now, utc_now())
    end

    def freeze(%DateTime{} = on) do
      Process.put(:mock_utc_now, on)
    end

    def unfreeze do
      Process.delete(:mock_utc_now)
    end

    defmacro time_travel(to, do: block) do
      quote do
        alias ExBin.Clock                                                         # Make it so blocks passed in can reference Clock easily.
        previous = if Process.get(:mock_utc_now), do: Clock.utc_now, else: nil    # save the current time if it's been frozen
        Clock.freeze(unquote(to))                                                 # freeze the clock at the new time
        result = unquote(block)                                                   # run the test block
        if previous, do: Clock.freeze(previous), else: Clock.unfreeze             # reset the clock back to the previous time if it was frozen, or unfreeze if it wasn't
        result                                                                    # and return the result
      end
    end
  else
    defdelegate utc_now, to: DateTime
  end
end
