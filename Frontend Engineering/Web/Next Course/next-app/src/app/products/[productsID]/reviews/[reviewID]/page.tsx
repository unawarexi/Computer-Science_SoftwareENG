import { Params } from "next/dist/shared/lib/router/utils/route-matcher";
import { notFound } from "next/navigation";

export default function reviewDetail({
  params,
}: {
  params: { productsID: string; reviewID: string };
}) {
  if (parseInt(params.reviewID) > 1000) {
    notFound();
  }
  return (
    <h1>
      Review {params.reviewID} of product {params.productsID}
    </h1>
  );
}
