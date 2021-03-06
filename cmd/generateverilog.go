// Copyright 2018 Franz Schmidt
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 		http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"github.com/spf13/cobra"
	"go.uber.org/zap"

	"github.com/kinnarr/fsmconverter/config"
	"github.com/kinnarr/fsmconverter/generation"
	"github.com/kinnarr/fsmconverter/optimization"
	"github.com/kinnarr/fsmconverter/validation"
)

var outputDir string

func init() {
	generationVerilogCmd.Flags().StringVarP(&outputDir, "output", "o", "fsmoutput", "Output directory for generated verilog code")
	rootCmd.AddCommand(generationVerilogCmd)
}

var generationVerilogCmd = &cobra.Command{
	Use:   "generateverilog",
	Short: "Generates verilog from the fsm config",
	Run: func(cmd *cobra.Command, args []string) {
		if !config.ParseConfig() {
			return
		}

		if !validation.ValidateStates() || !validation.ValidateDefaults() {
			zap.S().Errorf("Validation failed! See errors above!\n")
			return
		}

		if config.Optimize {
			optimization.OptimizeConfig()

			if !validation.ValidateStates() || !validation.ValidateDefaults() {
				zap.S().Errorf("Validation failed! See errors above!\n")
				return
			}
		}

		generation.GenerateVerilog(outputDir)
	},
}
