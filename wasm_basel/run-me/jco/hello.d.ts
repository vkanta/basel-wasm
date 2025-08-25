declare const DocsAdderTypes: {};
import { WasiCliEnvironment } from './interfaces/wasi-cli-environment.js';
import { WasiCliExit } from './interfaces/wasi-cli-exit.js';
import { WasiCliStderr } from './interfaces/wasi-cli-stderr.js';
import { WasiCliStdin } from './interfaces/wasi-cli-stdin.js';
import { WasiCliStdout } from './interfaces/wasi-cli-stdout.js';
declare const WasiClocksWallClock: {};
import { WasiFilesystemPreopens } from './interfaces/wasi-filesystem-preopens.js';
import { WasiFilesystemTypes } from './interfaces/wasi-filesystem-types.js';
import { WasiIoError } from './interfaces/wasi-io-error.js';
import { WasiIoStreams } from './interfaces/wasi-io-streams.js';
import { DocsAdderAdd } from './interfaces/docs-adder-add.js';
import { DocsCalculateCalculate } from './interfaces/docs-calculate-calculate.js';
export const add: typeof DocsAdderAdd;
export const calculate: typeof DocsCalculateCalculate;

export const $init: Promise<void>;
