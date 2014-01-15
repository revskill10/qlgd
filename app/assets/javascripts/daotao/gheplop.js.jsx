 /** @jsx React.DOM */


 var GhepLop = React.createClass({
 	
 	getInitialState: function(){
 		return {sinh_vien_id: -1, ma_lop_hanh_chinh: -1, lop_id: -1}
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
                                         page_limit: 30, // page size
                                         page: page, // page number                                
                                 };                                        
                         },
                         results: function (data, page) {
                                 var more = (page * 30) < data.total; // whether or not there are more results available
                                
                                 // notice we return the value of more so Select2 knows if more results can be loaded
                                 return {results: data.lop_hanh_chinhs, more: more};
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
                                         page_limit: 30, // page size
                                         page: page, // page number                                
                                 };                                        
                         },
                         results: function (data, page) {
                                 var more = (page * 30) < data.total; // whether or not there are more results available
                                
                                 // notice we return the value of more so Select2 knows if more results can be loaded
                                 return {results: data.lop_mon_hocs, more: more};
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
                                         page_limit: 30, // page size
                                         page: page, // page number                                
                                 };                                        
                         },
                         results: function (data, page) {
                                 var more = (page * 30) < data.total; // whether or not there are more results available
                                
                                 // notice we return the value of more so Select2 knows if more results can be loaded
                                 return {results: data.sinh_viens, more: more};
                                },
                                text: function(object) { return object; },
                                id: function(object) { return object; }
                 }
                });
 	},
 	getLopHanhChinh: function(){
 		var lhc = $('#lhc').val();
 		var lmh = $('#lmh').val(); 		
 		if (lhc != null && lmh != null) {
 			this.setState({ma_lop_hanh_chinh: lhc, lop_id: lmh});
 			React.unmountAndReleaseReactRootNode(document.getElementById('kq'));
 			React.renderComponent(<LopHanhChinh ma_lop_hanh_chinh={lhc} lop_id={lmh} />, document.getElementById('kq'));
 		} else if (sv != null && lmh != null) {
 			this.setState({sinh_vien_id: sv, lop_id: lmh});
 		} else {
 			alert('Bạn phải chọn lớp hành chính, hoặc sinh viên, hoặc lớp môn học');
 		}
 	},
 	render: function(){ 		
 		return (
 			<div>
 				<div class="row">
 					<div class="col-md-6"> 					
 						<h4>Chọn lớp hành chính</h4> 				
 						<input type="hidden" id="lhc" style={{width:"500px"}} class="input-xlarge" />
 						<button onClick={this.getLopHanhChinh} class="btn btn-success">Chọn</button>
 						<hr />
 						<h4>Chọn sinh viên</h4> 				
 						<input type="hidden" id="sv" style={{width:"500px"}} class="input-xlarge" />
 					</div>
 					<div class="col-md-6">
 						<h4>Chọn lớp Môn học</h4> 				
 				 		<input type="hidden" id="lmh" style={{width:"500px"}} class="input-xlarge" />
 					</div> 						
 				</div>
 				<div class="row" id="kq">
 					
 				</div>
 			</div>
 		);
 	}
 });
 
 var LopHanhChinh = React.createClass({
 	getInitialState: function(){
 		return {data: [], checked: []}
 	},
 	loadData: function(){
 		$.ajax({
	      url: "/daotao/lop_hanh_chinhs",
	      type: 'POST',
	      data: {ma_lop_hanh_chinh: this.props.ma_lop_hanh_chinh},
	      success: function(data) {             
	        this.setState({data: data});         
	      }.bind(this)
	    });
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	onMove: function(){
 		var results = [];
		$('input[id^=svs]').each(function(i, obj) {
		  if (obj.checked === true){
		      results.push(obj.value);
		  }
		});
		if (results.length > 0){
	 		$.ajax({
		      url: "/daotao/move",
		      type: 'POST',
		      data: {lop_id: this.props.lop_id, sinh_viens: results},
		      success: function(data) {             
		        this.setState({data: data});         
		      }.bind(this)
		    });
		}
 	}, 	
 	checkAll: function(){
 		$('input[id^=svs]').each(function(i, obj) {
		  obj.checked = !obj.checked;		      		 
		});
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <tr><td>{index+1}</td><td>{d.code}</td><td>{d.hovaten}</td><td>
 			<div class="checkbox">
		        <label>
		          <input id={'svs' + d.code} value={d.code} type="checkbox">Chọn</input>
		        </label>
		      </div>
 			</td></tr>
 		});
 		return (
 			<div class="row">
 				<div class="col-md-6 table-responsive">
 					<button onClick={this.onMove} class="btn btn-primary">Chuyển</button>
 					<hr/>
	 				<table class="table table-bordered">
	 					<thead>
	 						<tr class="success">
	 							<td>Stt</td><td>Mã sinh viên</td><td>Họ và tên</td><td>
	 							<div class="checkbox">
							        <label>
							          <input onClick={this.checkAll} type="checkbox">Chọn tất cả</input>
							        </label>
							      </div>
	 							</td>
	 						</tr>
	 					</thead>
	 					<tbody>
	 						{x}
	 					</tbody>
	 				</table>
	 			</div>
	 			<div class="col-md-6 table-responsive">
	 				<LopMonHoc lop_id={this.props.lop_id} />
	 			</div>
 			</div>
 		);
 	}
 });
var LopMonHoc = React.createClass({
	getInitialState: function(){
		return {data: []}
	},
	loadData: function(){
		$.ajax({
	      url: "/daotao/lop_mon_hocs",
	      type: 'POST',
	      data: {lop_id: this.props.lop_id},
	      success: function(data) {             
	        this.setState({data: data});         
	      }.bind(this)
	    });
	},
	componentWillMount: function(){
		this.loadData();
	},
	render: function(){
		var x = this.state.data.map(function(d, index){
			return <tr><td>{index+1}</td><td>{d.code}</td><td>{d.name}</td><td>{d.tinchi_status}</td></tr>
		});
		return (
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="success">
						<td>Stt</td>
						<td>Mã sinh viên</td>
						<td>Họ và tên</td>
						<td>Tín chỉ?</td>
					</tr>
				</thead>
				<tbody>
					{x}
				</tbody>
			</table>
		);
	}
});