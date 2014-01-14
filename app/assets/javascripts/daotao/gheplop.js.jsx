 /** @jsx React.DOM */

var xdata = {
	lop_hanh_chinhs: [
		{ma_lop_hanh_chinh: '1'},
		{ma_lop_hanh_chinh: '2'},
		{ma_lop_hanh_chinh: '3'}],
	lop_mon_hocs: [{lop_id: 1, lop:'l1'},
		{lop_id: 2, lop: 'l2'},
		{lop_id: 3, lop: 'l3'}],
	sinh_viens: [{sinh_vien_id: 1, hovaten: 's1'},
		{sinh_vien_id: 2, hovaten: 's2'},
		{sinh_vien_id: 3, hovaten: 's3'}]
};
 var GhepLop = React.createClass({
 	getInitialState: function(){
 		return {lop_hanh_chinhs: [], lop_mon_hocs: [], sinh_viens: []}
 	},
 	loadData: function(){
 		this.setState({lop_hanh_chinhs: xdata.lop_hanh_chinhs, lop_mon_hocs: xdata.lop_mon_hocs, sinh_viens: xdata.sinh_viens});
 	},
 	onChangeLopHanhChinh: function(ma_lop_hanh_chinh){
 		alert(ma_lop_hanh_chinh);
 	},
 	onChangeLopMonHoc: function(lop_id){

 	},
 	onChangeSinhVien: function(sinh_vien_id){

 	},
 	componentWillMount: function(){
 		this.loadData();
 	}, 	
 	componentDidMount: function(){ 		 		
		$("#lhc").select2({
		    placeholder: "Tìm lớp hành chính",
		    minimumInputLength: 3,
		    ajax: {
		    	url: "/daotao/lop_hanh_chinhs.json",			    	
				quietMillis: 100,
				data: function (term, page) { 
				    return {
					    q: term, //search term
					    page_limit: 10, // page size
					    page: page, // page number				    
				    };					    
		    	},
		    	results: function (data, page) {
				    var more = (page * 10) < data.total; // whether or not there are more results available
				     
				    // notice we return the value of more so Select2 knows if more results can be loaded
				    return {results: data, more: more};
				},
				text: function(object) { return object; },
				id: function(object) { return object; }
		    }
		});
		$("#lmh").select2({
		    placeholder: "Tìm lớp môn học",
		    minimumInputLength: 3,
		    ajax: {
		    	url: "/daotao/lop_mon_hocs.json",			    	
				quietMillis: 100,
				data: function (term, page) { 
				    return {
					    q: term, //search term
					    page_limit: 10, // page size
					    page: page, // page number				    
				    };					    
		    	},
		    	results: function (data, page) {
				    var more = (page * 10) < data.total; // whether or not there are more results available
				     
				    // notice we return the value of more so Select2 knows if more results can be loaded
				    return {results: data, more: more};
				},
				text: function(object) { return object; },
				id: function(object) { return object; }
		    }
		});
		$("#sv").select2({
		    placeholder: "Tìm sinh viên",
		    minimumInputLength: 3,
		    ajax: {
		    	url: "/daotao/sinh_viens.json",			    	
				quietMillis: 100,
				data: function (term, page) { 
				    return {
					    q: term, //search term
					    page_limit: 10, // page size
					    page: page, // page number				    
				    };					    
		    	},
		    	results: function (data, page) {
				    var more = (page * 10) < data.total; // whether or not there are more results available
				     
				    // notice we return the value of more so Select2 knows if more results can be loaded
				    return {results: data, more: more};
				},
				text: function(object) { return object; },
				id: function(object) { return object; }
		    }
		});
 	},
 	getLopHanhChinh: function(){
 		var lhc = $('#lhc').val();
 		var lmh = $('#lmh').val();
 		var sv = $('#sv').val();
 		if (lhc != null && lmh != null) {

 		} else if (sv != null && lmh != null) {

 		} else {
 			alert('Bạn phải chọn lớp hành chính, hoặc sinh viên, hoặc lớp môn học');
 		}
 	},
 	render: function(){ 		
 		return (
 			<div>
 				<div class="table-responsive">
 					<table class="table table-bordered">
 						<tbody>
 							<tr>
 								<td>
 								<h4>Chọn lớp hành chính</h4> 				
 				 <input type="hidden" id="lhc" style={{width:"500px"}} class="input-xlarge" />
 				 <button onClick={this.getLopHanhChinh} class="btn btn-success">Chọn</button>
 								<hr />
 								<h4>Chọn sinh viên</h4> 				
 				 <input type="hidden" id="sv" style={{width:"500px"}} class="input-xlarge" /></td>
 								<td><div>
 				<h4>Chọn lớp Môn học</h4> 				
 				 <input type="hidden" id="lmh" style={{width:"500px"}} class="input-xlarge" />
 			</div></td>
 							</tr>
 							<tr id="kq">
 								
 							</tr> 												
 						</tbody>
 					</table>
 				</div>
 			</div>
 		);
 	}
 });
 
 var LopHanhChinh = React.createClass({ 	 	
 	render: function(){
 		return (
 			<div>
 				
 			</div>
 		);
 	}
 });
 
 var SinhVien = React.createClass({
 	onChange: function(){
 		var sinh_vien_id = this.refs.sinh_vien_id.getDOMNode().value;
 		this.props.onChange(sinh_vien_id);
 	},
 	componentDidUpdate: function(){
 		$('.select2').select2();
 	},
 	render: function(){
 		var x = this.props.data.map(function(d){
 			return <option value={d.sinh_vien_id}>{d.hovaten}</option>
 		});
 		
 		return (
 			<div>
 				<h4>Chọn sinh viên</h4>
 				<select onChange={this.onChange} ref="sinh_vien_id" class="form-control input-sm select2">
					{x}
				</select>
 			</div>
 		);
 	}
 });
 var DSHanhChinh = React.createClass({
 	render: function(){
 		return (
 			<div></div>
 		)
 	}
 });
 var DSLopMonHoc = React.createClass({
 	render: function(){
 		return (
 			<div></div>
 		)
 	}
 });