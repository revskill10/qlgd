/** @jsx React.DOM */

var Search = React.createClass({
	render: function(){
		return (
			<div class="container">			
	  			<form role="form" class="form-horizontal">
	    			<div class="form-group">
	      				<div class="col-sm-8">
	        				<input type="text" class="form-control" placeholder="Thông tin tra cứu" name="query" />	      			
	      				</div>
	      				<button class="btn btn-primary btn-default">Tra cứu</button>
	      			</div>
	      		</form>
			</div>
		)		
	}
});

React.renderComponent(<Search />, document.getElementById("main"));