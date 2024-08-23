import { Params } from "next/dist/shared/lib/router/utils/route-matcher";

export default function reviewDetail({
  params,
}: {
  params: { productsID: string; reviewID: string };
}) {
  return (
    <h1>
      Review {params.reviewID} of product {params.productsID}
    </h1>
  );
}
