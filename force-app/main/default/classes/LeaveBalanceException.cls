/*****************************************************************
Name:          LeaveBalanceException
================================================================
Purpose:       Typed exception for the Employee Leave Balance
               Engine (Sprint 2). Allows engine-specific error
               signalling distinct from generic DmlException /
               QueryException so callers can handle balance
               failures precisely.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
*****************************************************************/
public class LeaveBalanceException extends Exception {}
