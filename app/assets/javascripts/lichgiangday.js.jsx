 /** @jsx React.DOM */

var ldata = [
	{id: 1, tuan: 1, thoi_gian: '6h30 12/08/2013', content: 'just a test'},
	{id: 2, tuan: 2, thoi_gian: '6h30 19/08/2013', content: 'just a test '}
];

 var LichGiangDay = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	loadData: function(){ 		
 		$.ajax({
	      url: "/lop/" +this.props.lop +"/" + this.props.giang_vien + "/lich_trinh_giang_days/content",	      
	      success: function(data) {             
	        this.setState({data: data});         
	      }.bind(this)
	    });
 	},
 	handleUpdate: function(data){
 		data.giang_vien = this.props.giang_vien;
 		$.ajax({
	      url: "/lop/" +this.props.lop + "/lich_trinh_giang_days/content",
	      type: 'POST',
	      data: data,
	      success: function(data) {             
	        this.setState({data: data});         
	      }.bind(this)
	    });
 	},
 	componentDidMount: function(){
 		this.loadData();
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d){
 			return <RowLichGiangDay onUpdate={self.handleUpdate} data={d} />
 		});
 		return ( 			 		
 			<ul>
 				{x}
 			</ul> 			
 		);
 	}
 });

 var RowLichGiangDay = React.createClass({
 	getInitialState: function(){
 		return {edit: 0};
 	},
 	onEdit: function(){
 		this.setState({edit: 1});
 	},
 	onCancel: function(){
 		this.setState({edit: 0});
 	},
 	onUpdate: function(){
 		var content = this.refs.content.getDOMNode().value;
 		this.setState({edit: 0});
 		this.props.data.content = content;
 		this.props.onUpdate(this.props.data);
 	},
 	componentDidUpdate: function(){
 		if (this.state.edit === 1){
 			this.refs.content.getDOMNode().value = this.props.data.content;
 		}
 	},
 	render: function(){

 		if (this.state.edit === 0){
 			return (
	 			<li><a href={"/lich/" + this.props.data.id}><strong>Tuần: {this.props.data.tuan}, {this.props.data.thoi_gian}</strong></a>
	 				<div>
	 					{this.props.data.content}
	 				</div>
	 				<button onClick={this.onEdit} class="btn btn-sm btn-default">Sửa nội dung</button>
	 				<hr />
	 			</li>
	 		);
 		} else {
 			return (
 				<li><a href={"/lich/" + this.props.data.id}><strong>Tuần: {this.props.data.tuan}, {this.props.data.thoi_gian}</strong></a>
 					<div>
 						<textarea ref='content' className='expanding' placeholder='Nội dung buổi học...' style={{width: '100%', minHeight: 200}} />
 					</div>
 					<button onClick={this.onCancel} class="btn btn-sm btn-default">Hủy</button>
 					<button onClick={this.onUpdate} class="btn btn-sm btn-primary">Cập nhật</button>
 					<hr />
 				</li>
 			);
 		}	
 	}
});