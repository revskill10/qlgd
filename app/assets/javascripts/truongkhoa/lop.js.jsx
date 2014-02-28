/** @jsx React.DOM */

var Lop = React.createClass({
	render: function(){
		return (
			<div class="panel-group" id="accordion">
				<div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href="#tslh">
			          Thông số lớp học
			        </a>
			      </h4>
			    </div>
			    <div id="tslh" class="panel-collapse collapse">
				      <div class="panel-body">
				      		Thông số lớp học
				      </div>
			    </div>
			    <div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href="#ltth">
			          Lịch trình thực hiện
			        </a>
			      </h4>
			    </div>
			    <div id="ltth" class="panel-collapse collapse">
				      <div class="panel-body">
				      	Lịch trình thực hiện
				      </div>
			    </div>
			    <div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href="#thht">
			          Tình hình học tập
			        </a>
			      </h4>
			    </div>
			    <div id="thht" class="panel-collapse collapse">
				      <div class="panel-body">
				      		Tình hình học tập
				      </div>
			    </div>
			</div>	
		)
	}
});
React.renderComponent(<Lop lop_id={ENV.lop_id} />, document.getElementById('tkmain'));