/*
 * rtwdemo_secondOrderSystem_data.c
 *
 * Code generation for model "rtwdemo_secondOrderSystem".
 *
 * Model version              : 5.1
 * Simulink Coder version : 9.7 (R2022a) 13-Nov-2021
 * C source code generated on : Mon Oct  9 18:02:01 2023
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objective: Debugging
 * Validation result: Not run
 */

#include "rtwdemo_secondOrderSystem.h"

/* Block parameters (default storage) */
P_rtwdemo_secondOrderSystem_T rtwdemo_secondOrderSystem_P = {
  /* Expression: 0
   * Referenced by: '<Root>/Integrator1'
   */
  0.0,

  /* Expression: 397.0116577148438
   * Referenced by: '<Root>/Damping'
   */
  397.01165771484381,

  /* Expression: 4
   * Referenced by: '<Root>/Force: f(t)'
   */
  4.0,

  /* Expression: 20
   * Referenced by: '<Root>/Force: f(t)'
   */
  20.0,

  /* Expression: 0
   * Referenced by: '<Root>/Integrator2'
   */
  0.0,

  /* Expression: 1000000
   * Referenced by: '<Root>/Stiffness'
   */
  1.0E+6,

  /* Expression: 1000000
   * Referenced by: '<Root>/Mass'
   */
  1.0E+6
};
