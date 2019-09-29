{-
    Copyright 2012-2019 Vidar Holen

    This file is part of ShellCheck.
    https://www.shellcheck.net

    ShellCheck is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ShellCheck is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
-}
module ShellCheck.Analyzer
  ( analyzeScript
  , ShellCheck.Analyzer.optionalChecks
  ) where

import Data.List
import Data.Monoid
import ShellCheck.Analytics
import ShellCheck.AnalyzerLib
import qualified ShellCheck.Checks.Commands
import qualified ShellCheck.Checks.Custom
import qualified ShellCheck.Checks.ShellSupport
import ShellCheck.Interface

-- TODO: Clean up the cruft this is layered on
analyzeScript :: AnalysisSpec -> AnalysisResult
analyzeScript spec =
  newAnalysisResult
    { arComments =
        filterByAnnotation spec params . nub $
        runAnalytics spec ++ runChecker params (checkers params)
    }
  where
    params = makeParameters spec

checkers params =
  mconcat $
  map
    ($ params)
    [ ShellCheck.Checks.Commands.checker
    , ShellCheck.Checks.Custom.checker
    , ShellCheck.Checks.ShellSupport.checker
    ]

optionalChecks = mconcat $ [ShellCheck.Analytics.optionalChecks]
