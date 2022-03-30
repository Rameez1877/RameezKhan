/****** Object:  Procedure [dbo].[InsertuserCredit]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<SYED>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertuserCredit] 
(
@UserID					INT,
@CreditConsumedorGained INT,
@ItemID					INT,
@PlanID					INT,
@ProductID				INT,
@CreditTransactionID	INT
)
AS
BEGIN
DECLARE @TRANSACTIONDATE DATETIME = GETDATE(),
		@QUANTITY INT,
		@PRICE INT,
		@ERROR_MESSAGE VARCHAR(500),
		@TouchPointsCount INT,@CRMCount INT

		SELECT @TouchPointsCount = COUNT(*) from [dbo].TouchProfilesAppUsers
									where AppUserID = @UserID

		SELECT @CRMCount = COUNt(*) FROM [dbo].HubSpotApiKey WHERE userid =@UserID

	 SELECT @QUANTITY=Quantity FROM PlanMaster WHERE PlanID = @PlanID

	IF NOT EXISTS(SELECT TOP 1 1 FROM USERCREDIT WHERE UserID = @UserID)
	BEGIN
	PRINT '57'
		
		INSERT INTO USERCREDIT ([UserID],[CreditsBalanceAtLastInventory],[CreditConsumedorGained],[TransactionDate],[CreditTransactionID],PlanID)
		vALUES (@UserID,@QUANTITY,@CreditConsumedorGained,@TRANSACTIONDATE,@CreditTransactionID,@PlanID)
		IF(@@ROWCOUNT >0)
		BEGIN
			SELECT @ERROR_MESSAGE ='Inserted Sucessfully'
		END
		ELSE
		BEGIN
			SELECT @ERROR_MESSAGE ='Insertion Failed'
		END
	END
	ELSE
	BEGIN
	IF(@CRMCount=0)
	BEGIN
	PRINT '74'
	DECLARE @CreditsBalanceAtLastInventory INT
	SELECT @CreditsBalanceAtLastInventory =CreditsBalanceAtLastInventory FROM UserCredit WHERE UserID = @UserID
		INSERT INTO USERCREDIT ([UserID],[CreditsBalanceAtLastInventory],[CreditConsumedorGained],[TransactionDate],[CreditTransactionID],PlanID)
		vALUES (@UserID,@CreditsBalanceAtLastInventory+@CreditConsumedorGained,@CreditConsumedorGained,@TRANSACTIONDATE,@CreditTransactionID,@PlanID)
		 IF(@@ROWCOUNT >0)
		 BEGIN
			SELECT @ERROR_MESSAGE ='Inserted Sucessfully'
		 END
		 ELSE
		 BEGIN
			 SELECT @ERROR_MESSAGE ='Insertion Failed'
		 END
	END
	ELSE IF (@TouchPointsCount=0)
	begin
	PRINT '89'
			SELECT @CreditsBalanceAtLastInventory =CreditsBalanceAtLastInventory FROM UserCredit WHERE UserID = @UserID
		INSERT INTO USERCREDIT ([UserID],[CreditsBalanceAtLastInventory],[CreditConsumedorGained],[TransactionDate],[CreditTransactionID],PlanID)
		vALUES (@UserID,@CreditsBalanceAtLastInventory+@CreditConsumedorGained,@CreditConsumedorGained,@TRANSACTIONDATE,@CreditTransactionID,@PlanID)
		 IF(@@ROWCOUNT >0)
		 BEGIN
			SELECT @ERROR_MESSAGE ='Inserted Sucessfully'
		 END
		 ELSE
	     BEGIN
			SELECT @ERROR_MESSAGE ='Insertion Failed'
		 END
	 END
	 else
	 BEGIN
	 PRINT '104'
	 	SELECT @CreditsBalanceAtLastInventory =CreditsBalanceAtLastInventory FROM UserCredit WHERE UserID = @UserID
		INSERT INTO USERCREDIT ([UserID],[CreditsBalanceAtLastInventory],[CreditConsumedorGained],[TransactionDate],[CreditTransactionID],PlanID)
		vALUES (@UserID,@CreditsBalanceAtLastInventory-@CreditConsumedorGained,@CreditConsumedorGained,@TRANSACTIONDATE,@CreditTransactionID,@PlanID)
		 IF(@@ROWCOUNT >0)
		 BEGIN
			SELECT @ERROR_MESSAGE ='Inserted Sucessfully'
		 END
		 ELSE
	     BEGIN
			SELECT @ERROR_MESSAGE ='Insertion Failed'
		 END
	 END
	 END
	 SELECT @ERROR_MESSAGE AS ERROR_MESSAGE
END
