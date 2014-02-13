/** @jsx React.DOM */

var Search = React.createClass({
	onSearch: function(){		
		var type = this.refs.mtype.getDOMNode().selected;
		var query = this.refs.query.getDOMNode().value;
		alert(type);	
	},
	render: function(){
		return (
			<div class="container">				  			
    			<div class="form-group">
    			    <div class="col-sm-2">
    			    	<select ref="mtype" class="form-control" value="1">
    			    		<option value="1">Sinh viên</option>
    			    		<option value="2">Lớp môn học</option>
    			    		<option value="3">Lịch trình giảng dạy</option>
    			    	</select>
    			    </div>
      				<div class="col-sm-6">
        				<input type="text" ref="query" class="form-control" placeholder="Thông tin tra cứu" name="query" />	      			
      				</div>
      				<button onClick="onSearch" class="btn btn-primary btn-default">Tra cứu</button>
      			</div>	      		
	      		<div id="searchResult"></div>
			</div>
		)		
	}
});

var SinhVienSearchResult = React.createClass({
	render: function(){
		return (
			<div>
			</div>
		);
	}
});
var LopMonHocSearchResult = React.createClass({
	render: function(){
		return (
			<div>
			</div>
		);
	}
});
var LichSearchResult = React.createClass({
	render: function(){
		return (
			<div>
			</div>
		);
	}
});

React.renderComponent(<Search />, document.getElementById("main"));