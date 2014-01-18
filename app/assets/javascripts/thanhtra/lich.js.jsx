/** @jsx React.DOM */


var ThanhTra = React.createClass({
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
      url: '/thanhtra/lich_trinh_giang_days',
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
  handleDiMuon: function(d){    
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/dimuon',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleBoTiet: function(d){    
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/botiet',
      type: 'POST',
      data: d,
      success: function(data){          
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleVeSom: function(d){    
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/vesom',
      type: 'POST',
      data: d,
      success: function(data){          
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleReport: function(d){
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/report',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleUnReport: function(d){
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/unreport',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleRemove: function(d){
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/remove',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleRestore: function(d){
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/restore',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleConfirm: function(d){
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/confirm',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleUpdate: function(d){    
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days/update',
      type: 'POST',
      data: d,
      success: function(data){        
        this.setState({data: data});
      }.bind(this)
    });
  },
  render: function(){
    var self = this;
    var x = this.state.data.map(function(d, index){
      return <ThanhTraRow date={self.state.date} onReport={self.handleReport} onUnReport={self.handleUnReport} onRemove={self.handleRemove} onConfirm={self.handleConfirm} onRestore={self.handleRestore} onUpdate={self.handleUpdate} onDiMuon={self.handleDiMuon} onVeSom={self.handleVeSom} onBoTiet={self.handleBoTiet} data={d} stt={index+1} color={index % 2 === 0 ? 'danger' : 'warning'} />
    });
    
    return (
      <div>
        <div class="input-append date">
          <input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
          <button class="btn btn-sm btn-primary" onClick={this.handleDate}>Chọn ngày</button>          
        </div>
        <hr />
        <div class="table-responsive">      
          <table class="table table-bordered">
            <colgroup>
              <col style={{width: "5%"}} />
              <col style={{width: "30%"}} />
              <col style={{width: "10%"}} />
              <col style={{width: "15%"}} />
              <col style={{width: "15%"}} />
              <col style={{width: "15%"}} />
              <col style={{width: "10%"}} />
            </colgroup>
            <thead>
              <tr class="success">
                <td>Stt</td><td>Giờ học</td><td>Báo lỗi</td><td>Note 1</td><td>Note 2</td><td>Note 3</td><td>Thao tác</td>
              </tr>
            </thead>
            <tbody>
              {x}
            </tbody>
          </table>
        </div>
      </div>
    );        
  }
});

var ThanhTraRow = React.createClass({
  getInitialState: function(){
    return {edit: 0};
  },
  onDiMuon: function(){
    this.props.onDiMuon({lich_id: this.props.data.id, date: this.props.date});
  },
  onVeSom: function(){
    this.props.onVeSom({lich_id: this.props.data.id, date: this.props.date});
  },
  onBoTiet: function(){
    this.props.onBoTiet({lich_id: this.props.data.id, date: this.props.date});
  },
  onEdit: function(){
    this.setState({edit: 1});
  },
  onCancel: function(){
    this.setState({edit: 0});
  },
  onUpdate: function(){
    this.setState({edit: 0});
    var note1 = this.refs.note1.getDOMNode().value;
    var note3 = this.refs.note3.getDOMNode().value;
    this.props.onUpdate({lich_id: this.props.data.id, note1: note1, note3: note3, date: this.props.date});
  },  
  onReport: function(){    
    this.props.onReport({lich_id: this.props.data.id, date: this.props.date});
  },
  onUnReport: function(){    
    this.props.onUnReport({lich_id: this.props.data.id, date: this.props.date});
  },
  onRemove: function(){    
    this.props.onRemove({lich_id: this.props.data.id, date: this.props.date});
  },
  onConfirm: function(){    
    this.props.onConfirm({lich_id: this.props.data.id, date: this.props.date});
  },
  onRestore: function(){    
    this.props.onRestore({lich_id: this.props.data.id, date: this.props.date});
  },
  componentDidUpdate: function(){
    if (this.state.edit === 1){
      this.refs.note1.getDOMNode().value = this.props.data.note1;
      this.refs.note3.getDOMNode().value = this.props.data.note3;
    }
  },
  render: function(){
    if (this.state.edit === 0){
      return (      
        <tr class={this.props.color}>
          <td>{this.props.stt}</td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.info}} /></td>
          <td><button onClick={this.onDiMuon} class={this.props.data.di_muon_color} >{this.props.data.di_muon_alias}</button><br/><br/><button onClick={this.onVeSom} class={this.props.data.ve_som_color} >{this.props.data.ve_som_alias}</button><br/><br/><button onClick={this.onBoTiet} class={this.props.data.bo_tiet_color} >{this.props.data.bo_tiet_alias}</button></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note1_html}} /></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note2_html}} /></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note3_html}} /></td>
          <td>
            <button style={{display: this.props.data.can_thanh_tra_edit === true ? '' : 'none'}} onClick={this.onEdit} class="btn btn-sm btn-success">Edit</button>
            <button style={{display: this.props.data.can_report === true ? '' : 'none'}} onClick={this.onReport} class="btn btn-sm btn-danger">Report</button>
            <button style={{display: this.props.data.can_unreport === true ? '' : 'none'}} onClick={this.onUnReport} class="btn btn-sm btn-danger">UnReport</button>
            <button style={{display: this.props.data.can_remove === true ? '' : 'none'}} onClick={this.onRemove} class="btn btn-sm btn-warning">Remove</button>
            <button style={{display: this.props.data.can_restore === true ? '' : 'none'}} onClick={this.onRestore} class="btn btn-sm btn-warning">Restore</button>
            <button style={{display: this.props.data.can_confirm === true ? '' : 'none'}} onClick={this.onConfirm} class="btn btn-sm btn-primary">Confirm</button>
          </td>
        </tr>
      );
    } else {
      return (
        <tr class={this.props.color}>
          <td>{this.props.stt}</td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.info}} /></td>
          <td><button onClick={this.onDiMuon} class={this.props.data.di_muon_color} >{this.props.data.di_muon_alias}</button><br/><br/><button onClick={this.onVeSom} class={this.props.data.ve_som_color} >{this.props.data.ve_som_alias}</button><br/><br/><button onClick={this.onBoTiet} class={this.props.data.bo_tiet_color} >{this.props.data.bo_tiet_alias}</button></td>
          <td><textarea ref="note1" style={{width:"100%", height: "200px"}} /></td>
          <td>{this.props.data.note2}</td>
          <td><textarea ref="note3" style={{width:"100%", height: "200px"}} /></td>
          <td>
            <button onClick={this.onCancel} class="btn btn-sm btn-default">Hủy</button>
            <button onClick={this.onUpdate} class="btn btn-sm btn-success">Cập nhật</button>
            <button style={{display: this.props.data.can_report === true ? '' : 'none'}} onClick={this.onReport} class="btn btn-sm btn-danger">Report</button>
            <button style={{display: this.props.data.can_unreport === true ? '' : 'none'}} onClick={this.onUnReport} class="btn btn-sm btn-danger">UnReport</button>
            <button style={{display: this.props.data.can_remove === true ? '' : 'none'}} onClick={this.onRemove} class="btn btn-sm btn-warning">Remove</button>
            <button style={{display: this.props.data.can_restore === true ? '' : 'none'}} onClick={this.onRestore} class="btn btn-sm btn-warning">Restore</button>
            <button style={{display: this.props.data.can_confirm === true ? '' : 'none'}} onClick={this.onConfirm} class="btn btn-sm btn-primary">Confirm</button>
          </td>
        </tr>
      );
    }
    
  }
});