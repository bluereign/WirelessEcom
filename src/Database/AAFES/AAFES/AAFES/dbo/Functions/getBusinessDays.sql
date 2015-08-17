

CREATE FUNCTION [dbo].[getBusinessDays] (@start_date datetime, @end_date datetime)
  RETURNS INT
  AS
  BEGIN
  
	  DECLARE @RemoveDays int
      DECLARE @EndDatePart int
      DECLARE @StartDatePart int
      DECLARE @DayDiff int
      
      SET @EndDatePart = datepart(weekday, @end_date)
      SET @StartDatePart = datepart(weekday, @start_date)
      SET @DayDiff = datediff(d, @start_date, @end_date)
      
   -- Sun = 1
   -- Mon = 2
   -- Tue = 3
   -- Wed = 4
   -- Thu = 5
   -- Fri = 6
   -- Sat = 7
      SET @RemoveDays = -1
          
      
      IF (@StartDatePart=1 AND @EndDatePart=4)
      BEGIN        
		SET @RemoveDays = 0         
      END   
      
      IF (@StartDatePart=1 AND @EndDatePart=3)
      BEGIN        
		SET @RemoveDays = 0         
      END   
             
      IF (@StartDatePart=1 AND @EndDatePart=5)
      BEGIN
		SET @RemoveDays = 0         
      END                         
                        
      
      IF (@StartDatePart=1 AND @EndDatePart=2)
      BEGIN
		SET @RemoveDays = 0         
      END                
      
      IF (@StartDatePart=1 AND @EndDatePart=6)
      BEGIN
		SET @RemoveDays = 0         
      END 
       
      IF (@StartDatePart=1 AND @EndDatePart=7)
      BEGIN
		SET @RemoveDays = -1         
      END
           
      IF (@StartDatePart=1 AND @EndDatePart=1)
      BEGIN
       if @DayDiff > 1
       begin
		SET @RemoveDays = -2        
	   end
	   else
	   begin
	   SET @RemoveDays = -1         
	   end
      END
           
      IF (@StartDatePart=2 AND @EndDatePart=6)
      BEGIN
		SET @RemoveDays = 1         
      END 
       
      IF (@StartDatePart=2 AND @EndDatePart=5)
      BEGIN
		SET @RemoveDays = 1        
      END 
              
      IF (@StartDatePart=2 AND @EndDatePart=3)
      BEGIN
		SET @RemoveDays = 1     
      END 
                
      IF (@StartDatePart=2 AND @EndDatePart=4)
      BEGIN
		SET @RemoveDays = 1     
      END 
      
      IF (@StartDatePart=2 AND @EndDatePart=7)
      BEGIN
		SET @RemoveDays = 2         
      END        
         
        IF (@StartDatePart=2 AND @EndDatePart=2)
      BEGIN
		SET @RemoveDays = 1         
      END      
       
      IF (@StartDatePart=3) AND (@EndDatePart=7)  
      BEGIN
       SET @RemoveDays = -2
      END      
       
      IF (@StartDatePart=3) AND (@EndDatePart=2)  
      BEGIN
       SET @RemoveDays = 1
      END
       
      IF (@StartDatePart=3) AND (@EndDatePart=3)  
      BEGIN
       SET @RemoveDays = 1
      END
       
      IF (@StartDatePart=3) AND (@EndDatePart=4)  
      BEGIN
       SET @RemoveDays = 1
      END
       
      IF (@StartDatePart=3) AND (@EndDatePart=5)  
      BEGIN
       SET @RemoveDays = 1
      END
       
      IF (@StartDatePart=3) AND (@EndDatePart=6)  
      BEGIN
       SET @RemoveDays = 3
      END
       
      IF (@StartDatePart=3) AND (@EndDatePart=7)  
      BEGIN
       SET @RemoveDays = 2
      END
            
      IF (@StartDatePart=4) AND (@EndDatePart=2)  
      BEGIN
       SET @RemoveDays = 1
      END
                 
      IF (@StartDatePart=4) AND (@EndDatePart=3)  
      BEGIN
       SET @RemoveDays = 1
      END
      
      IF (@StartDatePart=4) AND (@EndDatePart=4)  
      BEGIN
       SET @RemoveDays = 1
      END
      
      IF (@StartDatePart=4) AND (@EndDatePart=5)  
      BEGIN
       SET @RemoveDays = 3
      END
      
      IF (@StartDatePart=4) AND (@EndDatePart=6)  
      BEGIN
       SET @RemoveDays = 3
      END
      
      IF (@StartDatePart=4) AND (@EndDatePart=7)  
      BEGIN
       SET @RemoveDays = 2
      END
      
      IF (@StartDatePart=5 AND @EndDatePart=7)
      BEGIN        
		SET @RemoveDays = 0         
      END    
      
      IF (@StartDatePart=5 AND @EndDatePart=2)
      BEGIN        
		SET @RemoveDays = 1         
      END    
                             
      IF (@StartDatePart=5 AND @EndDatePart=6)
      BEGIN        
		SET @RemoveDays = 1         
      END      
      
      IF (@StartDatePart=5 AND @EndDatePart=3)
      BEGIN        
		SET @RemoveDays = 1         
      END      

      IF (@StartDatePart=5 AND @EndDatePart=4)
      BEGIN        
		SET @RemoveDays = 1        
      END      

      IF (@StartDatePart=5 AND @EndDatePart=5)
      BEGIN   
      if @DayDiff > 1
		BEGIN     
			SET @RemoveDays = 1       
		end
		else
		begin
			SET @RemoveDays = 1        
		end
      END      
      
      IF (@StartDatePart=7 AND @EndDatePart=4)
      BEGIN
		SET @RemoveDays = 1         
      END 
      
      IF (@StartDatePart=7 AND @EndDatePart=3)
      BEGIN
		SET @RemoveDays = 1         
      END 
    
     IF (@StartDatePart=6 AND @EndDatePart=5)
      BEGIN
		SET @RemoveDays = 1         
      END      
         
      IF (@StartDatePart=6 AND @EndDatePart=4)
      BEGIN
		SET @RemoveDays = 1         
      END    
      
     IF (@StartDatePart=6 AND @EndDatePart=3)
      BEGIN
		SET @RemoveDays = 1        
      END
               
      IF (@StartDatePart=6) AND (@EndDatePart=7)  
      BEGIN
       SET @RemoveDays = 2
      END      
      
      IF (@StartDatePart=6) AND (@EndDatePart=2)  
      BEGIN
       SET @RemoveDays = 1
      END             
      
      IF (@StartDatePart=6) AND (@EndDatePart=6)  
      BEGIN
       SET @RemoveDays = 3
      END      
      
      IF (@StartDatePart=7) AND (@EndDatePart=2)  
      BEGIN
       SET @RemoveDays = 1
      END      
      
      IF (@StartDatePart=7) AND (@EndDatePart=6)  
      BEGIN
       SET @RemoveDays = 1
      END
                  
      IF (@StartDatePart=7) AND (@EndDatePart=5)  
      BEGIN
       SET @RemoveDays = 1
      END           
      
      IF (@StartDatePart=7 AND @EndDatePart=7)
      BEGIN		
		if @DayDiff > 1
		BEGIN
			SET @RemoveDays = 2
		END
		ELSE
		BEGIN
	        SET @RemoveDays = 3  
        END
      END
      
      IF (@StartDatePart=7) AND (@EndDatePart=1)  
      BEGIN
      if @DayDiff > 1
      begin
       SET @RemoveDays = 1
       end
       else
       begin
       SET @RemoveDays = 2
       end
      END                    
               

      SET @end_date = dateadd(d,@RemoveDays,@end_date)
           
      RETURN (datediff(d,@start_date,@end_date)+1) - (datediff(ww,@start_date,@end_date) * 2)
  
  END