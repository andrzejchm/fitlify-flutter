import 'package:kt_dart/kt.dart';

class PaginatedList<T> {
  final Pagination nextPage;
  final KtList<T> list;

  PaginatedList(this.nextPage, this.list);

  bool get isLast => nextPage == null;
}

class Pagination {
  final dynamic next;

  Pagination(this.next);

  Pagination.firstPage() : next = null;
}
