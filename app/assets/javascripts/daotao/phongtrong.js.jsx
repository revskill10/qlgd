 /** @jsx React.DOM */

 var PhongTrong = React.createClass({
 	getInitialState: function(){
 		return {data: [], date: ''}
 	},
  	componentDidMount: function(){    
	    $('.input-append.date').datepicker({
	      format: "dd/mm/yyyy",
	      startDate: "13/1/2014",
	      todayBtn: "linked",
	        language: "vi",
	        autoClose: true,
	        todayHighlight: true
	    });   	    
	},
	handleDate: function(){    				
	    var date = this.refs.thoi_gian.getDOMNode().value;
	    $('.input-append.date').datepicker('hide');
	    this.setState({date: date});
	    $.ajax({
	      url: '/daotao/phongtrong',
	      type: 'POST',
	      data: {date: date},
	      success: function(data){          
	        this.setState({data: data});
	      }.bind(this)
	    });
	  },
	componentDidUpdate: function(){    	

	    $('.input-append.date').datepicker({
	      format: "dd/mm/yyyy",
	      startDate: "13/1/2014",
	      todayBtn: "linked",
	        language: "vi",
	        autoClose: true,
	        todayHighlight: true
	    });   
	    this.refs.thoi_gian.getDOMNode().value = this.state.date;    
	    
	},
 	render: function(){
 		var x = this.state.data.map(function(d, index){
 			return <PhongTrongItem stt={index+1} data={d} key={d.phong} />
 		});
 		return (
 			<div>
 				<br />
 				<div class="input-append date">
		          <input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
		          <button class="btn btn-sm btn-primary" onClick={this.handleDate}>Chọn ngày</button>          
		        </div>
		        <hr />
	 			<div class="table-responsive">
	 				<table class="table table-bordered">
	 					<thead>
	 						<tr class="success">
	 							<td>Phòng</td>
	 							<td>Ca 1</td>
	 							<td>Ca 2</td>
	 							<td>Ca 3</td>
	 							<td>Ca 4</td>
	 						</tr>
	 					</thead>
	 					<tbody>
	 						{x}
	 					</tbody>
	 				</table>
	 			</div>
 			</div>
 		)
 	}
 });
 var PhongTrongItem = React.createClass({ 	
 	render: function(){
 		var self = this;
 		var y = [1,2,3,4].map(function(item, index){
 			var temp = <td></td>;
 			if (self.props.data.data.length > 0) {
 				self.props.data.data.forEach(function(d){ 		
 				if (d.ca === item) { 					
 					temp =  <td><a href={'/lich/' + d.id}>{d.ten_mon_hoc}</a><br/>{d.giang_vien}</td>	
 				}		
	 			
	 		});		
 			} 			
	 		return temp;
 		});
 		
 		return (
 			<tr class={this.props.stt % 2 === 0 ? 'danger' : 'warning'}>
 				<td>{this.props.data.phong}</td>
 				{y}
 			</tr>
 		)
 	}
 });
