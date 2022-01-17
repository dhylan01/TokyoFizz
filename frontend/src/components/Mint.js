import React from "react";

export function Mint({ }) {
  return (
    <div>
      <h4>Mint</h4>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();
          
          const formData = new FormData(event.target);
          const to = formData.get("to");
          const amount = formData.get("amount");
          
           //maybe make a mintable if statement in contract???
          Mint();
        }}
      >

      
        <div className="form-group">
        
          <label>Amount of {tokenSymbol}</label>
          <input
          //idk how to call a function to get the amnt of tokens left here 
            className="form-control"
            type="number"
            step="1"
            name="amount"
            placeholder="1"
            required
          />
        </div>
        <div className="form-group">
          <label>Recipient address</label>
          <input className="form-control" type="text" name="to" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Transfer" />
        </div>
      </form>
    </div>
  );
}
