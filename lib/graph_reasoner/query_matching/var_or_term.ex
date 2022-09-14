defmodule GraphReasoner.QueryMatching.VarOrTerm do
  alias Updates.QueryAnalyzer.Iri
  alias InterpreterTerms.SymbolMatch, as: Sym

  @moduledoc """
  Provides helpers for working with VarOrTerm.  Mainly simple ways of
  extracting the information which is nested more deeply in this
  construction.
  """

  @doc """
  Yields a truethy result if this VarOrTerm contains a variable.
  """
  def var?(%Sym{symbol: :VarOrTerm, submatches: [%Sym{symbol: :Var, submatches: [_symbol]}]}),
    do: true

  def var?(_), do: false

  @doc """
  Yields a truethy result if this VarOrTerm contains a term.
  """
  def term?(%Sym{symbol: :VarOrTerm, submatches: [%Sym{symbol: :GraphTerm} = _graphTerm]}),
    do: true

  def term?(_), do: false

  @doc """
  Yields a truethy result if this VarOrTerm contains a term which is
  an IRI.
  """
  def iri?(term) do
    if term?(term) do
      term = term!(term)
      match?(%Sym{symbol: :GraphTerm, submatches: [%Sym{symbol: :iri}]}, term)
    else
      false
    end
  end

  @doc """
  Yields the variable of the supplied symbol (throws an error when it
  is not a variable).
  """
  def var!(%Sym{symbol: :VarOrTerm, submatches: [%Sym{symbol: :Var} = var]}),
    do: var

  @doc """
  Yields the term of the supplied symbol (throws an error when it is
  not a term).
  """
  def term!(%Sym{symbol: :VarOrTerm, submatches: [%Sym{symbol: :GraphTerm} = term]}),
    do: term

  @doc """
  Yields the iri of the supplied symbol (throws an error when it does
  not contain an Iri).
  """
  def iri!(symbol) do
    iri!(symbol, %{})
  end

  def iri!(symbol, prologue_info) do
    %Sym{symbol: :GraphTerm, submatches: [%Sym{symbol: :iri} = iri]} = term!(symbol)

    Iri.from_symbol(iri, prologue_info)
  end
end
