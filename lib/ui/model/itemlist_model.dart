class itemlist_model{

  late var custcd;
  late var flag;
  late var inputdate;
  late var itemsubject;
  late var pernm;
  late var itemmemo;
  late var location;
  late var flagnm;
  late var endmemo;
  late var boxpass;
  late var enddate;

  var seq;



  itemlist_model({
    this.seq,  this.custcd,   this.flag,  this.inputdate, this.itemsubject, this.pernm,
    this.itemmemo, this.location, this.flagnm, this.endmemo, this.boxpass, this.enddate
  });
}


List<itemlist_model> itemData = [];
