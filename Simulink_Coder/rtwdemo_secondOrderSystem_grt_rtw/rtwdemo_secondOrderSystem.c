/*
 * rtwdemo_secondOrderSystem.c
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
#include <math.h>
#include "rtwtypes.h"
#include "rtwdemo_secondOrderSystem_private.h"
#include "rt_nonfinite.h"
#include "rtwdemo_secondOrderSystem_dt.h"

/* Block signals (default storage) */
B_rtwdemo_secondOrderSystem_T rtwdemo_secondOrderSystem_B;

/* Continuous states */
X_rtwdemo_secondOrderSystem_T rtwdemo_secondOrderSystem_X;

/* Real-time model */
static RT_MODEL_rtwdemo_secondOrderS_T rtwdemo_secondOrderSystem_M_;
RT_MODEL_rtwdemo_secondOrderS_T *const rtwdemo_secondOrderSystem_M =
  &rtwdemo_secondOrderSystem_M_;

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 2;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  rtwdemo_secondOrderSystem_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  rtwdemo_secondOrderSystem_step();
  rtwdemo_secondOrderSystem_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  rtwdemo_secondOrderSystem_step();
  rtwdemo_secondOrderSystem_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void rtwdemo_secondOrderSystem_step(void)
{
  real_T temp;
  if (rtmIsMajorTimeStep(rtwdemo_secondOrderSystem_M)) {
    /* set solver stop time */
    if (!(rtwdemo_secondOrderSystem_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&rtwdemo_secondOrderSystem_M->solverInfo,
                            ((rtwdemo_secondOrderSystem_M->Timing.clockTickH0 +
        1) * rtwdemo_secondOrderSystem_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&rtwdemo_secondOrderSystem_M->solverInfo,
                            ((rtwdemo_secondOrderSystem_M->Timing.clockTick0 + 1)
        * rtwdemo_secondOrderSystem_M->Timing.stepSize0 +
        rtwdemo_secondOrderSystem_M->Timing.clockTickH0 *
        rtwdemo_secondOrderSystem_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(rtwdemo_secondOrderSystem_M)) {
    rtwdemo_secondOrderSystem_M->Timing.t[0] = rtsiGetT
      (&rtwdemo_secondOrderSystem_M->solverInfo);
  }

  /* Integrator: '<Root>/Integrator1' */
  rtwdemo_secondOrderSystem_B.X = rtwdemo_secondOrderSystem_X.Integrator1_CSTATE;

  /* Gain: '<Root>/Damping' */
  rtwdemo_secondOrderSystem_B.Damping = rtwdemo_secondOrderSystem_P.Damping_Gain
    * rtwdemo_secondOrderSystem_B.X;

  /* SignalGenerator: '<Root>/Force: f(t)' */
  temp = rtwdemo_secondOrderSystem_P.Forceft_Frequency *
    rtwdemo_secondOrderSystem_M->Timing.t[0];
  if (temp - floor(temp) >= 0.5) {
    /* SignalGenerator: '<Root>/Force: f(t)' */
    rtwdemo_secondOrderSystem_B.Forceft =
      rtwdemo_secondOrderSystem_P.Forceft_Amplitude;
  } else {
    /* SignalGenerator: '<Root>/Force: f(t)' */
    rtwdemo_secondOrderSystem_B.Forceft =
      -rtwdemo_secondOrderSystem_P.Forceft_Amplitude;
  }

  /* End of SignalGenerator: '<Root>/Force: f(t)' */

  /* Integrator: '<Root>/Integrator2' */
  rtwdemo_secondOrderSystem_B.X_o =
    rtwdemo_secondOrderSystem_X.Integrator2_CSTATE;

  /* Gain: '<Root>/Stiffness' */
  rtwdemo_secondOrderSystem_B.Stiffness =
    rtwdemo_secondOrderSystem_P.Stiffness_Gain * rtwdemo_secondOrderSystem_B.X_o;

  /* Gain: '<Root>/Mass' */
  rtwdemo_secondOrderSystem_B.Mass = rtwdemo_secondOrderSystem_P.Mass_Gain *
    rtwdemo_secondOrderSystem_B.Forceft;

  /* MATLAB Function: '<Root>/MATLAB Function' */
  /* :  X = (-Stiffness+Mass-Damping); */
  rtwdemo_secondOrderSystem_B.X_f = (-rtwdemo_secondOrderSystem_B.Stiffness +
    rtwdemo_secondOrderSystem_B.Mass) - rtwdemo_secondOrderSystem_B.Damping;
  if (rtmIsMajorTimeStep(rtwdemo_secondOrderSystem_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(rtwdemo_secondOrderSystem_M->rtwLogInfo,
                        (rtwdemo_secondOrderSystem_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(rtwdemo_secondOrderSystem_M)) {
    /* External mode */
    rtExtModeUploadCheckTrigger(2);

    {                                  /* Sample time: [0.0s, 0.0s] */
      rtExtModeUpload(0, (real_T)rtwdemo_secondOrderSystem_M->Timing.t[0]);
    }

    if (rtmIsMajorTimeStep(rtwdemo_secondOrderSystem_M)) {/* Sample time: [0.001s, 0.0s] */
      rtExtModeUpload(1, (real_T)
                      (((rtwdemo_secondOrderSystem_M->Timing.clockTick1+
                         rtwdemo_secondOrderSystem_M->Timing.clockTickH1*
                         4294967296.0)) * 0.001));
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(rtwdemo_secondOrderSystem_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(rtwdemo_secondOrderSystem_M)!=-1) &&
          !((rtmGetTFinal(rtwdemo_secondOrderSystem_M)-
             (((rtwdemo_secondOrderSystem_M->Timing.clockTick1+
                rtwdemo_secondOrderSystem_M->Timing.clockTickH1* 4294967296.0)) *
              0.001)) > (((rtwdemo_secondOrderSystem_M->Timing.clockTick1+
                           rtwdemo_secondOrderSystem_M->Timing.clockTickH1*
                           4294967296.0)) * 0.001) * (DBL_EPSILON))) {
        rtmSetErrorStatus(rtwdemo_secondOrderSystem_M, "Simulation finished");
      }

      if (rtmGetStopRequested(rtwdemo_secondOrderSystem_M)) {
        rtmSetErrorStatus(rtwdemo_secondOrderSystem_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&rtwdemo_secondOrderSystem_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++rtwdemo_secondOrderSystem_M->Timing.clockTick0)) {
      ++rtwdemo_secondOrderSystem_M->Timing.clockTickH0;
    }

    rtwdemo_secondOrderSystem_M->Timing.t[0] = rtsiGetSolverStopTime
      (&rtwdemo_secondOrderSystem_M->solverInfo);

    {
      /* Update absolute timer for sample time: [0.001s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.001, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      rtwdemo_secondOrderSystem_M->Timing.clockTick1++;
      if (!rtwdemo_secondOrderSystem_M->Timing.clockTick1) {
        rtwdemo_secondOrderSystem_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void rtwdemo_secondOrderSystem_derivatives(void)
{
  XDot_rtwdemo_secondOrderSyste_T *_rtXdot;
  _rtXdot = ((XDot_rtwdemo_secondOrderSyste_T *)
             rtwdemo_secondOrderSystem_M->derivs);

  /* Derivatives for Integrator: '<Root>/Integrator1' */
  _rtXdot->Integrator1_CSTATE = rtwdemo_secondOrderSystem_B.X_f;

  /* Derivatives for Integrator: '<Root>/Integrator2' */
  _rtXdot->Integrator2_CSTATE = rtwdemo_secondOrderSystem_B.X;
}

/* Model initialize function */
void rtwdemo_secondOrderSystem_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)rtwdemo_secondOrderSystem_M, 0,
                sizeof(RT_MODEL_rtwdemo_secondOrderS_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
                          &rtwdemo_secondOrderSystem_M->Timing.simTimeStep);
    rtsiSetTPtr(&rtwdemo_secondOrderSystem_M->solverInfo, &rtmGetTPtr
                (rtwdemo_secondOrderSystem_M));
    rtsiSetStepSizePtr(&rtwdemo_secondOrderSystem_M->solverInfo,
                       &rtwdemo_secondOrderSystem_M->Timing.stepSize0);
    rtsiSetdXPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
                 &rtwdemo_secondOrderSystem_M->derivs);
    rtsiSetContStatesPtr(&rtwdemo_secondOrderSystem_M->solverInfo, (real_T **)
                         &rtwdemo_secondOrderSystem_M->contStates);
    rtsiSetNumContStatesPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
      &rtwdemo_secondOrderSystem_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
      &rtwdemo_secondOrderSystem_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
      &rtwdemo_secondOrderSystem_M->periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
      &rtwdemo_secondOrderSystem_M->periodicContStateRanges);
    rtsiSetErrorStatusPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
                          (&rtmGetErrorStatus(rtwdemo_secondOrderSystem_M)));
    rtsiSetRTModelPtr(&rtwdemo_secondOrderSystem_M->solverInfo,
                      rtwdemo_secondOrderSystem_M);
  }

  rtsiSetSimTimeStep(&rtwdemo_secondOrderSystem_M->solverInfo, MAJOR_TIME_STEP);
  rtwdemo_secondOrderSystem_M->intgData.y = rtwdemo_secondOrderSystem_M->odeY;
  rtwdemo_secondOrderSystem_M->intgData.f[0] = rtwdemo_secondOrderSystem_M->
    odeF[0];
  rtwdemo_secondOrderSystem_M->intgData.f[1] = rtwdemo_secondOrderSystem_M->
    odeF[1];
  rtwdemo_secondOrderSystem_M->intgData.f[2] = rtwdemo_secondOrderSystem_M->
    odeF[2];
  rtwdemo_secondOrderSystem_M->contStates = ((X_rtwdemo_secondOrderSystem_T *)
    &rtwdemo_secondOrderSystem_X);
  rtsiSetSolverData(&rtwdemo_secondOrderSystem_M->solverInfo, (void *)
                    &rtwdemo_secondOrderSystem_M->intgData);
  rtsiSetIsMinorTimeStepWithModeChange(&rtwdemo_secondOrderSystem_M->solverInfo,
    false);
  rtsiSetSolverName(&rtwdemo_secondOrderSystem_M->solverInfo,"ode3");
  rtmSetTPtr(rtwdemo_secondOrderSystem_M,
             &rtwdemo_secondOrderSystem_M->Timing.tArray[0]);
  rtmSetTFinal(rtwdemo_secondOrderSystem_M, 0.2);
  rtwdemo_secondOrderSystem_M->Timing.stepSize0 = 0.001;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = (NULL);
    rtwdemo_secondOrderSystem_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    /*
     * Set pointers to the data and signal info each state
     */
    {
      static int_T rt_LoggedStateWidths[] = {
        1,
        1
      };

      static int_T rt_LoggedStateNumDimensions[] = {
        1,
        1
      };

      static int_T rt_LoggedStateDimensions[] = {
        1,
        1
      };

      static boolean_T rt_LoggedStateIsVarDims[] = {
        0,
        0
      };

      static BuiltInDTypeId rt_LoggedStateDataTypeIds[] = {
        SS_DOUBLE,
        SS_DOUBLE
      };

      static int_T rt_LoggedStateComplexSignals[] = {
        0,
        0
      };

      static RTWPreprocessingFcnPtr rt_LoggingStatePreprocessingFcnPtrs[] = {
        (NULL),
        (NULL)
      };

      static const char_T *rt_LoggedStateLabels[] = {
        "CSTATE",
        "CSTATE"
      };

      static const char_T *rt_LoggedStateBlockNames[] = {
        "rtwdemo_secondOrderSystem/Integrator1",
        "rtwdemo_secondOrderSystem/Integrator2"
      };

      static const char_T *rt_LoggedStateNames[] = {
        "",
        ""
      };

      static boolean_T rt_LoggedStateCrossMdlRef[] = {
        0,
        0
      };

      static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert[] = {
        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 },

        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 }
      };

      static RTWLogSignalInfo rt_LoggedStateSignalInfo = {
        2,
        rt_LoggedStateWidths,
        rt_LoggedStateNumDimensions,
        rt_LoggedStateDimensions,
        rt_LoggedStateIsVarDims,
        (NULL),
        (NULL),
        rt_LoggedStateDataTypeIds,
        rt_LoggedStateComplexSignals,
        (NULL),
        rt_LoggingStatePreprocessingFcnPtrs,

        { rt_LoggedStateLabels },
        (NULL),
        (NULL),
        (NULL),

        { rt_LoggedStateBlockNames },

        { rt_LoggedStateNames },
        rt_LoggedStateCrossMdlRef,
        rt_RTWLogDataTypeConvert
      };

      static void * rt_LoggedStateSignalPtrs[2];
      rtliSetLogXSignalPtrs(rtwdemo_secondOrderSystem_M->rtwLogInfo,
                            (LogSignalPtrsType) rt_LoggedStateSignalPtrs);
      rtliSetLogXSignalInfo(rtwdemo_secondOrderSystem_M->rtwLogInfo,
                            &rt_LoggedStateSignalInfo);
      rt_LoggedStateSignalPtrs[0] = (void*)
        &rtwdemo_secondOrderSystem_X.Integrator1_CSTATE;
      rt_LoggedStateSignalPtrs[1] = (void*)
        &rtwdemo_secondOrderSystem_X.Integrator2_CSTATE;
    }

    rtliSetLogT(rtwdemo_secondOrderSystem_M->rtwLogInfo, "tout");
    rtliSetLogX(rtwdemo_secondOrderSystem_M->rtwLogInfo, "xout");
    rtliSetLogXFinal(rtwdemo_secondOrderSystem_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(rtwdemo_secondOrderSystem_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(rtwdemo_secondOrderSystem_M->rtwLogInfo, 2);
    rtliSetLogMaxRows(rtwdemo_secondOrderSystem_M->rtwLogInfo, 0);
    rtliSetLogDecimation(rtwdemo_secondOrderSystem_M->rtwLogInfo, 1);
    rtliSetLogY(rtwdemo_secondOrderSystem_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(rtwdemo_secondOrderSystem_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(rtwdemo_secondOrderSystem_M->rtwLogInfo, (NULL));
  }

  /* External mode info */
  rtwdemo_secondOrderSystem_M->Sizes.checksums[0] = (4044367636U);
  rtwdemo_secondOrderSystem_M->Sizes.checksums[1] = (657649702U);
  rtwdemo_secondOrderSystem_M->Sizes.checksums[2] = (2886156340U);
  rtwdemo_secondOrderSystem_M->Sizes.checksums[3] = (1893095546U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[2];
    rtwdemo_secondOrderSystem_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(rtwdemo_secondOrderSystem_M->extModeInfo,
      &rtwdemo_secondOrderSystem_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(rtwdemo_secondOrderSystem_M->extModeInfo,
                        rtwdemo_secondOrderSystem_M->Sizes.checksums);
    rteiSetTPtr(rtwdemo_secondOrderSystem_M->extModeInfo, rtmGetTPtr
                (rtwdemo_secondOrderSystem_M));
  }

  /* block I/O */
  {
    rtwdemo_secondOrderSystem_B.X = 0.0;
    rtwdemo_secondOrderSystem_B.Damping = 0.0;
    rtwdemo_secondOrderSystem_B.Forceft = 0.0;
    rtwdemo_secondOrderSystem_B.X_o = 0.0;
    rtwdemo_secondOrderSystem_B.Stiffness = 0.0;
    rtwdemo_secondOrderSystem_B.Mass = 0.0;
    rtwdemo_secondOrderSystem_B.X_f = 0.0;
  }

  /* states (continuous) */
  {
    (void) memset((void *)&rtwdemo_secondOrderSystem_X, 0,
                  sizeof(X_rtwdemo_secondOrderSystem_T));
  }

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    rtwdemo_secondOrderSystem_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 18;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.PTransTable = &rtPTransTable;
  }

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(rtwdemo_secondOrderSystem_M->rtwLogInfo, 0.0,
    rtmGetTFinal(rtwdemo_secondOrderSystem_M),
    rtwdemo_secondOrderSystem_M->Timing.stepSize0, (&rtmGetErrorStatus
    (rtwdemo_secondOrderSystem_M)));

  /* InitializeConditions for Integrator: '<Root>/Integrator1' */
  rtwdemo_secondOrderSystem_X.Integrator1_CSTATE =
    rtwdemo_secondOrderSystem_P.Integrator1_IC;

  /* InitializeConditions for Integrator: '<Root>/Integrator2' */
  rtwdemo_secondOrderSystem_X.Integrator2_CSTATE =
    rtwdemo_secondOrderSystem_P.Integrator2_IC;
}

/* Model terminate function */
void rtwdemo_secondOrderSystem_terminate(void)
{
  /* (no terminate code required) */
}
