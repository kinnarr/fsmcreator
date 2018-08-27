{{/*
  Copyright 2018 Franz Schmidt

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  		http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/}}
module cu (
  state_set,
  state,
  {{ range $outputName, $outputLenght := .Outputs -}}
  {{$outputName}},
  {{end -}}
  );
  {{$countStates := len $.States}}
  {{$binaryStateSize := getBinarySize $countStates }}
  parameter SIZE = {{ $binaryStateSize }};

  input wire [SIZE-1:0] state;
  input wire state_set;

  {{ range $outputName, $outputLenght := .Outputs -}}
  output reg {{if gt $outputLenght 1}}[{{minus $outputLenght 1}}:0] {{end}}{{$outputName}};
  {{end -}}

  parameter {{ range $index, $stateName := enumerateKeys .States }}{{$stateName}} = {{convertBinary $index $binaryStateSize}}{{if ne $index (minus $countStates 1)}}, {{end}}{{end}};

  always @ (state_set)
  begin
    {{ range $outputName, $outputValue := .Defaults.Outputs -}}
    {{$outputName}} = {{convertBinary $outputValue (index $.Outputs $outputName)}};
    {{end -}}
    case(state)
    {{- range $stateName, $state := .States}}
      {{$stateName}} : begin
            {{range $outputName, $outputValue := $state.Outputs -}}
              {{$outputName}} = {{convertBinary $outputValue (index $.Outputs $outputName)}};
            {{end -}}
          end
    {{end -}}
    endcase
  end
endmodule